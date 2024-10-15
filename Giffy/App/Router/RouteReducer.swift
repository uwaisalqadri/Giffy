//
//  RouteReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RouteReducer {
  @ObservableState
  struct State: Equatable {
    var main: MainTabReducer.State = .init()
    var home: HomeReducer.State = .init()
    var search: SearchReducer.State = .init()
    var favorite: FavoriteReducer.State = .init()
    var detail: DetailReducer.State = .init(item: .init())
  }

  @CasePathable
  enum Action: CasePathable {
    case main(MainTabReducer.Action)
    case home(HomeReducer.Action)
    case search(SearchReducer.Action)
    case favorite(FavoriteReducer.Action)
    case detail(DetailReducer.Action)
  }

  var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      default:
        return .none
      }
    }

    Scope(state: \.main, action: \.main) {
      MainTabReducer()
    }

    Scope(state: \.home, action: \.home) {
      HomeReducer(useCase: Injection.resolve())
    }

    Scope(state: \.search, action: \.search) {
      SearchReducer(useCase: Injection.resolve())
    }

    Scope(state: \.favorite, action: \.favorite) {
      FavoriteReducer(useCase: Injection.resolve(), removeUseCase: Injection.resolve())
    }
  }
}
