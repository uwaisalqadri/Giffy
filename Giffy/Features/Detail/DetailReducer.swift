//
//  DetailPresenter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI
import ActivityKit
import SwiftUI
import SDWebImage

@Reducer
public struct DetailReducer {
  
  private let checkFavoriteUseCase: CheckFavoriteUseCase
  private let addFavoriteUseCase: AddFavoriteUseCase
  private let removeFavoriteUseCase: RemoveFavoriteUseCase
  
  init(
    checkFavoriteUseCase: CheckFavoriteUseCase,
    addFavoriteUseCase: AddFavoriteUseCase,
    removeFavoriteUseCase: RemoveFavoriteUseCase
  ) {
    self.checkFavoriteUseCase = checkFavoriteUseCase
    self.addFavoriteUseCase = addFavoriteUseCase
    self.removeFavoriteUseCase = removeFavoriteUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    var items: [Giffy]
    var item: Giffy
    init(items: [Giffy]) {
      self.items = items
      self.item = items.first(where: \.isHighlighted)!
    }
    
    var isFavorited: Bool = false
    var isLoading: Bool = false
    var errorMessage: String = ""
    var isError: Bool = false
    var shareImage: Data?
    var hearts: [HeartModel] = []
    
    var share: StoreOf<ShareReducer> {
      Store(initialState: .init(shareImage)) {
        ShareReducer()
      }
    }
  }
  
  public enum Action {
    case checkFavorite
    case addFavorite
    case removeFavorite
    case onDisappear
    case startLiveActivity(DetailReducer.State)
    case updateHighlight(Giffy)
    case displayHeart(location: CGPoint)
    case takeOffHeart(_ heartId: UUID)
    case prepareShare
    case showShare(Data?)
    case failedShare
    case success(isFavorited: Bool)
    case failed(error: Error)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .checkFavorite:
        state.isLoading = true
        let item = state.item
        return .run { send in
          do {
            let response = try await checkFavoriteUseCase.execute(request: item.id)
            await send(.success(isFavorited: response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .prepareShare:
        state.isLoading = true
        let imageUrl = state.item.image.url
        return .run { send in
          do {
            let imageData = try await downloadImage(from: URL(string: imageUrl))
            await send(.showShare(imageData))
          } catch {
            await send(.failedShare)
          }
        }
        
      case let .showShare(image):
        state.isLoading = false
        state.shareImage = image
        return .none
      
      case .failedShare:
        state.isLoading = false
        Toaster.error(message: "Can't share the GIF").show()
        return .none
        
      case .success(let isFavorited):
        state.isLoading = false
        state.isFavorited = isFavorited
        return .none
        
      case .failed:
        state.isLoading = false
        state.isFavorited = false
        Toaster.error(message: Localizable.errorCheckFavorite.tr()).show()
        return .none
        
      case .addFavorite:
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        
        let item = state.item
        return .run { send in
          do {
            _ = try await addFavoriteUseCase.execute(request: item)
            await send(.success(isFavorited: true))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .removeFavorite:
        let item = state.item
        return .run { send in
          do {
            _ = try await removeFavoriteUseCase.execute(request: item)
            await send(.success(isFavorited: false))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .startLiveActivity(let state):
        return .run { _ in
          let attributes = GiphyAttributes(title: state.item.title)
          let attributeState = GiphyAttributes.FavoriteState(isFavorited: state.isFavorited)
          
          let content = ActivityContent(state: attributeState, staleDate: nil)
          let activity = try? Activity<GiphyAttributes>.request(attributes: attributes, content: content)
          
          try await Task.sleep(for: .seconds(3))
          await activity?.end(content, dismissalPolicy: .immediate)
        }
        
      case let .displayHeart(location):
        let heart = HeartModel(location: location)
        state.hearts.append(heart)
        
        let heartId = heart.id
        
        return .run { send in
          try await Task.sleep(for: .seconds(1))
          await send(.takeOffHeart(heartId))
        }
        
      case let .takeOffHeart(heartId):
        state.hearts.removeAll(where: { $0.id == heartId })
        return .none
        
      case .onDisappear:
        if let position = state.items.firstIndex(where: { $0.id == state.item.id }) {
          Notifications.onDetailDisappear.post(with: position)
        }
        return .none
        
      case let .updateHighlight(giffy):
        state.item = giffy
        return .run { send in
          await send(.checkFavorite)
        }
      }
    }
  }
  
  private func downloadImage(from url: URL?) async throws -> Data? {
    return try await withCheckedThrowingContinuation { continuation in
      SDWebImageManager.shared.loadImage(
        with: url,
        options: [.queryMemoryData],
        progress: nil
      ) { image, data, error, _, _, _ in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        
        if let data = data, let animatedImage = SDAnimatedImage(data: data) {
          continuation.resume(returning: animatedImage.animatedImageData)
          return
        }
        
        continuation.resume(throwing: NSError(domain: "Failed to decode animated image", code: -1))
      }
    }
  }

}

enum ShareError: Error {
  case fail
}
