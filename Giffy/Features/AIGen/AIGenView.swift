//
//  StickerView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 10/11/24.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI
import CommonUI
import ComposableArchitecture

struct AIGenView: View {
  let store: StoreOf<AIGenReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        ForEach(viewStore.images, id: \.self) { image in
          WebImage(url: URL(string: image))
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 80)
        }
      }
      .onAppear {
        viewStore.send(.onPrompt("ninja"))
      }
    }
  }
}
