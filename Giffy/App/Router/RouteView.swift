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
import CommonUI

struct RouteView: View {
  let store: StoreOf<RouteReducer>
  @Router var router

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      RouteProvider(router.self) { route in
        switch route {
        case .main:
          MainTabView(store: viewStore.main)

        case .home:
          HomeView(store: viewStore.home)

        case .search:
          SearchView(store: viewStore.search)

        case .favorite:
          FavoriteView(store: viewStore.favorite)

        case let .detail(items):
          DetailView(store: viewStore[detail: items])
        }
      }
    }
  }
}
