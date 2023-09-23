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

struct FavoriteView: ViewControllable {
  var holder: Common.NavStackHolder
  let router: DetailRouter
  
  var store: StoreOf<FavoriteReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        SearchInput { query in
          viewStore.send(.fetch(request: query))
        }.padding(.top, 30)

        if !viewStore.state.list.isEmpty {
          LazyVStack {
            ForEach(
              Array(viewStore.state.list.enumerated()),
              id: \.offset
            ) { _, item in
              SearchRow(isFavorite: true, giphy: item, onTapRow: { giphy in
                guard let viewController = holder.viewController else { return }
                router.routeToDetail(from: viewController, giphy: giphy)
              }, onRemoveFavorite: { giphy in
                viewStore.send(.removeFavorite(item: giphy, request: ""))
              })
              .padding(.vertical, 20)
              .padding(.horizontal, 20)
            }
          }
        } else {
          isFavoriteEmpty.padding(.top, 50)
        }

      }
      .navigationTitle(FavoriteString.titleFavorite.localized)
      .onAppear {
        viewStore.send(.fetch(request: ""))
      }
      .onDisappear {
        viewStore.send(.fetch(request: ""))
      }
    }
  }
  
  var isFavoriteEmpty: some View {
    VStack {
      LottieView(fileName: "add_to_favorite", bundle: Bundle.common, loopMode: .loop)
        .frame(width: 220, height: 220)
      Text(FavoriteString.labelFavoriteEmpty.localized)
    }
  }

}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteView(holder: Injection.shared.resolve(), router: Injection.shared.resolve(), store: Injection.shared.resolve())
  }
}
