//
//  TabReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 8/10/23.
//

import SwiftUI
import Common
import ComposableArchitecture
import TCACoordinators

public enum Tabs: Int, CaseIterable {
  case home
  case search
  
  var iconName: String {
    switch self {
    case .home:
      return "rectangle.3.offgrid"
    case .search:
      return "rectangle.stack"
    }
  }
  
  var iconColor: Color {
    switch self {
    case .home:
      return .Theme.green
    case .search:
      return .Theme.blueSky
    }
  }
}

struct MainTabReducer: Reducer {
  struct State: Equatable {
    var selectedTab: Tabs = .home
    var home: HomeReducer.State = .init()
    var search: SearchReducer.State = .init()
  }
  
  @CasePathable
  enum Action: CasePathable {
    case home(HomeReducer.Action)
    case search(SearchReducer.Action)
    case selectedTabChanged(Tabs)
  }
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .selectedTabChanged(tab):
        state.selectedTab = tab
        return .none
      default:
        return .none
      }
    }

    Scope(state: \.home, action: \.home) {
      HomeReducer(useCase: Injection.resolve())
    }

    Scope(state: \.search, action: \.search) {
      SearchReducer(useCase: Injection.resolve())
    }
  }
}
