//
//  TabReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 8/10/23.
//

import SwiftUI
import Common
import ComposableArchitecture

public enum Tabs: Int, CaseIterable {
  case search
  case home

  var iconName: String {
    switch self {
    case .search:
      return "rectangle.3.offgrid"
    case .home:
      return "rectangle.stack"
    }
  }
  
  var iconColor: Color {
    switch self {
    case .search:
      return .Theme.green
    case .home:
      return .Theme.blueSky
    }
  }
}

@Reducer
struct MainTabReducer {
  struct State: Equatable {
    var selectedTab: Tabs = .search
    var home: HomeReducer.State = .init()
    var search: SearchReducer.State = .init()
  }
  
  @CasePathable
  enum Action: CasePathable {
    case home(HomeReducer.Action)
    case search(SearchReducer.Action)
    case selectedTabChanged(Tabs)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .selectedTabChanged(tab):
        state.selectedTab = tab
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
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
