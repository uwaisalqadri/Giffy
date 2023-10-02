//
//  AppCoordinator.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/9/23.
//

import Foundation
import SwiftUI
import Giphy
import ComposableArchitecture
import TCACoordinators

public struct AppScreen: Reducer {
  public enum State: Equatable {
    case detail(DetailReducer.State)
    case favorite(FavoriteReducer.State)
    case home(HomeReducer.State)
    case search(SearchReducer.State)
  }
  
  public enum Action {
    case detail(DetailReducer.Action)
    case favorite(FavoriteReducer.Action)
    case home(HomeReducer.Action)
    case search(SearchReducer.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: /State.detail, action: /Action.detail) {
      DetailReducer(checkUseCase: Injection.shared.resolve(), addUseCase: Injection.shared.resolve(), removeUseCase: Injection.shared.resolve())
    }
    
    Scope(state: /State.favorite, action: /Action.favorite) {
      FavoriteReducer(useCase: Injection.shared.resolve(), removeUseCase: Injection.shared.resolve())
    }
    
    Scope(state: /State.home, action: /Action.home) {
      HomeReducer(useCase: Injection.shared.resolve())
    }
    
    Scope(state: /State.search, action: /Action.search) {
      SearchReducer(useCase: Injection.shared.resolve())
    }
  }
}

public struct AppCoordinator: Reducer {
  public struct State: Equatable, IndexedRouterState {
    public static let rootHomeState = AppCoordinator.State(
      routes: [.root(.home(.init()), embedInNavigationView: true)]
    )
    
    public static let rootSearchState = AppCoordinator.State(
      routes: [.root(.search(.init()), embedInNavigationView: true)]
    )
    
    public var routes: [Route<AppScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: AppScreen.Action)
    case updateRoutes([Route<AppScreen.State>])
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .routeAction(_, action: .home(.showDetail(item))):
        state.routes.presentSheet(.detail(.init(item: item)))
        
      case .routeAction(_, action: .home(.openFavorite)):
        state.routes.push(.favorite(.init()))
        
      case let .routeAction(_, action: .search(.showDetail(item))):
        state.routes.presentSheet(.detail(.init(item: item)))
        
      case .routeAction(_, action: .search(.openFavorite)):
        state.routes.push(.favorite(.init()))
        
      default:
        break
      }
      
      return .none
      
    }.forEachRoute {
      AppScreen()
    }
  }
}
