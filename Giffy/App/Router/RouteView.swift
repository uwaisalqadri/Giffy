//
//  RouteView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Common

struct RouteView: View {
  let store: StoreOf<RouteReducer>
  @Route var router

  var body: some View {
    RouteProvider(router.self) { route in
      switch route {
      case .main:
        MainTabView(
          store: store.scope(
            state: \.main,
            action: \.main
          )
        )

      case .home:
        HomeView(
          store: store.scope(
            state: \.home,
            action: \.home
          )
        )

      case .search:
        SearchView(
          store: store.scope(
            state: \.search,
            action: \.search
          )
        )

      case .favorite:
        FavoriteView(
          store: store.scope(
            state: \.favorite,
            action: \.favorite
          )
        )

      case let .detail(item):
        DetailView(
          store: Store(initialState: DetailReducer.State(item: item)) {
            DetailReducer(
              checkUseCase: Injection.resolve(), addUseCase: Injection.resolve(), removeUseCase: Injection.resolve())
          }
        )
      }
    }
  }
}
