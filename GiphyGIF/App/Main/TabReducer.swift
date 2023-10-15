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
      return .green
    case .search:
      return .orange
    }
  }
}

struct MainTabReducer: Reducer {
  struct State: Equatable {
    var homeTab = AppCoordinator.State.rootHomeState
    var searchTab = AppCoordinator.State.rootSearchState
    var selectedTab: Tabs = .home
  }
  
  enum Action {
    case homeTab(AppCoordinator.Action)
    case searchTab(AppCoordinator.Action)
    case selectedTabChanged(Tabs)
  }
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .selectedTabChanged(tab):
        state.selectedTab = tab
        return .none
        
      case .homeTab, .searchTab:
        return .none
      }
    }
    Scope(state: \.homeTab, action: /Action.homeTab) {
      AppCoordinator()
    }
    Scope(state: \.searchTab, action: /Action.searchTab) {
      AppCoordinator()
    }
  }
}
