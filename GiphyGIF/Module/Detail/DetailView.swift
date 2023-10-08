//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Giphy
import Core
import Common
import ComposableArchitecture

struct DetailView: View {
  let store: StoreOf<DetailReducer>
    
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        WebView(url: URL(string: viewStore.state.item.url))
          .edgesIgnoringSafeArea([.bottom, .horizontal])
          .navigationBarItems(
            trailing: Button(action: {
              if viewStore.state.isFavorited {
                viewStore.send(.removeFavorite(item: viewStore.state.item))
              } else {
                viewStore.send(.addFavorite(item: viewStore.state.item))
              }
            }) {
              Image(viewStore.state.isFavorited ? "heart.fill" : "heart", bundle: Bundle.common)
                .resizable()
                .frame(width: 23, height: 20)
                .foregroundColor(.red)
            }
          )
          .navigationTitle(DetailString.titleDetail.localized)
          .navigationBarTitleDisplayMode(.inline)
          .onAppear {
            viewStore.send(.checkFavorite(request: viewStore.state.item.id))
          }
      }
    }
  }
}
