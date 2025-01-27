//
//  StickerReducer.swift
//  Giffy
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI
import PhotosUI
import _PhotosUI_SwiftUI

@Reducer
public struct StickerReducer {
  
  @Route var router
  private let backgroundRemovalUseCase: BackgroundRemovalUseCase

  init(backgroundRemovalUseCase: BackgroundRemovalUseCase) {
    self.backgroundRemovalUseCase = backgroundRemovalUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public static func == (lhs: StickerReducer.State, rhs: StickerReducer.State) -> Bool {
      lhs.showOriginalImage == rhs.showOriginalImage &&
      lhs.isPresentPhotoPicker == rhs.isPresentPhotoPicker &&
      lhs.selectedPhotoPickerItem == rhs.selectedPhotoPickerItem &&
      lhs.currentSticker.id == rhs.currentSticker.id &&
      lhs.isCopied == rhs.isCopied
    }
    
    var isCopied: Bool = false
    var showOriginalImage: Bool = false
    var isPresentPhotoPicker: Bool = false
    var selectedPhotoPickerItem: PhotosPickerItem?
    var currentSticker: Sticker = .init()
    
    var share: StoreOf<ShareReducer> {
      Store(
        initialState: .init(currentSticker.imageData?.outputImage?.pngData())
      ) {
        ShareReducer()
      }
    }
  }
  
  public enum Action {
    case loadInputImage(item: PhotosPickerItem?)
    case deleteImage
    case presentPhotoPicker(_ state: Bool)
    case toggleShowOriginalImage(_ state: Bool)
    case updateSticker(_ sticker: Sticker)
    case shareSticker
    case dismissShare
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .presentPhotoPicker(bool):
        state.isPresentPhotoPicker = bool
        return .none
        
      case let .loadInputImage(pickedItem):
        state.selectedPhotoPickerItem = pickedItem
        return .run { send in
          await loadInputImage(fromPhotosPickerItem: pickedItem, send: send)
        }
        
      case .deleteImage:
        state.isCopied = false
        return .run { send in
          await send(.updateSticker(.init(state: .none)))
        }
        
      case let .toggleShowOriginalImage(bool):
        state.showOriginalImage = bool
        return .none
        
      case let .updateSticker(sticker):
        state.isCopied = false
        state.currentSticker = sticker
        return .none
        
      case .shareSticker:
        guard let data = state.currentSticker.imageData?.outputImage?
          .pngData() else { return .none }
        state.isCopied = true
        return .none
        
      case .dismissShare:
        state.isCopied = false
        return .none
      }
    }
  }
  
  private func loadInputImage(fromPhotosPickerItem item: PhotosPickerItem?, send: Send<StickerReducer.Action>) async {
    await send(.updateSticker(.init(state: .generating)))

    guard let item = item else { return }
    
    do {
      let data = try await item.loadTransferable(type: Data.self)
      guard let imageData = data, var image = CIImage(data: imageData) else { return }
      
      if let orientation = image.properties["Orientation"] as? Int32, orientation != 1 {
        image = image.oriented(forExifOrientation: orientation)
      }
      
      try await onInputImageSelected(image, send: send)
      
    } catch {
      await Toaster.error(message: "Something is wrong").show()
    }
  }
  
  func onInputImageSelected(_ image: CIImage, send: Send<StickerReducer.Action>) async throws {
    do {
      let imageData = try await backgroundRemovalUseCase.execute(request: image)
      await send(.updateSticker(.init(state: .completed(imageData))))
    } catch let error as CancellationError {
      await send(.updateSticker(.init(state: .failure(error))))
    }
  }
}
