//
//  RouteReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import ComposableArchitecture
import Common

@Reducer
struct RouteReducer {
  @ObservableState
  struct State: Equatable {
    var main: StoreOf<MainTabReducer> = Store(initialState: .init()) {
      MainTabReducer()
    }
    
    var home: StoreOf<HomeReducer> = Store(initialState: .init()) {
      HomeReducer(trendingUseCase: Injection.resolve())
    }
    
    var search: StoreOf<SearchReducer> = Store(initialState: .init()) {
      SearchReducer(searchUseCase: Injection.resolve())
    }
    
    var favorite: StoreOf<FavoriteReducer> = Store(initialState: .init()) {
      FavoriteReducer(
        favoriteUseCase: Injection.resolve(),
        removeUseCase: Injection.resolve()
      )
    }
    
    subscript(detail giffies: [Giffy]) -> StoreOf<DetailReducer> {
      .init(initialState: .init(items: giffies)) {
        DetailReducer(
          checkFavoriteUseCase: Injection.resolve(),
          addFavoriteUseCase: Injection.resolve(),
          removeFavoriteUseCase: Injection.resolve()
        )
      }
    }
  }
}
