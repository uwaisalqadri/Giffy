//
//  FavoriteView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 26/05/21.
//

import SwiftUI
import Lottie
import Core
import Giphy
import Common
import ComposableArchitecture

struct FavoriteView: View {
  let store: StoreOf<FavoriteReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        SearchField { query in
          viewStore.send(.fetch(request: query))
        }.padding(.vertical, 20)
        
        if viewStore.state.list.isEmpty {
          FavoriteEmptyView()
            .padding(.top, 50)
        }
        
        LazyVStack {
          ForEach(viewStore.state.list, id: \.id) { item in
            GiphyItemRow(
              isFavorite: true,
              giphy: item,
              onTapRow: { giphy in
                viewStore.send(.showDetail(item: giphy))
              },
              onFavorite: { giphy in
                viewStore.send(.removeFavorite(item: giphy, request: ""))
              }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
          }
        }
      }
      .padding(.horizontal, 10)
      .navigationTitle(FavoriteString.titleFavorite.localized)
      .onAppear {
        viewStore.send(.fetch(request: ""))
      }
    }
  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteView(store: Injection.shared.resolve())
  }
}
