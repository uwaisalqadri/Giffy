//
//  StickerView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 10/11/24.
//

import SwiftUI
import CommonUI
import PhotosUI
import ComposableArchitecture

struct StickerView: View {
  let store: StoreOf<StickerReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 20) {
        Menu {
          Button("Select from Photo Library") {
            viewStore.send(.presentPhotoPicker(true))
          }
          
          if viewStore.state.currentSticker.imageData != nil {
            Button("Delete", role: .destructive) {
              viewStore.send(.deleteImage)
            }
          }
        } label: {
          let size = (window?.screen.bounds.width ?? 0.0) - 20
          ImageContainerView(
            sticker: viewStore.state.currentSticker,
            showOriginalImage: viewStore.state.showOriginalImage
          )
          .frame(width: size, height: size)
        }
        .disabled(viewStore.state.currentSticker.isGeneratingImage)
        .padding(.top, 80)
        
        Toggle("", isOn: viewStore.binding(
          get: { $0.showOriginalImage },
          send: { .toggleShowOriginalImage($0) }
        ).not)
        .labelsHidden()
        .tint(Gradient(colors: [.Theme.blueSky, .Theme.yellow]))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 20)
        
        Spacer()
      }
      .photosPicker(
        isPresented: viewStore.binding(
          get: { $0.isPresentPhotoPicker },
          send: { .presentPhotoPicker($0) }
        ),
        selection: viewStore.binding(
          get: { $0.selectedPhotoPickerItem },
          send: { .loadInputImage(item: $0) }
        ),
        matching: .images
      )
      .navigationTitle("Background Removal")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          IconButton(
            iconName: viewStore.state.isCopied ? "doc.on.clipboard.fill" : "doc.on.clipboard",
            tint: .Theme.green,
            size: 15,
            onClick: {
              viewStore.send(.copySticker)
            }
          )
          .tapScaleEffect()
        }
      }
    }
  }
}
