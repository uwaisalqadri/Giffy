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

struct AppCoordinatorView: View {
  let coordinator: StoreOf<AppCoordinator>
  
  var body: some View {
    TCARouter(coordinator) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .detail:
          CaseLet(
            /AppScreen.State.detail,
             action: AppScreen.Action.detail,
             then: DetailView.init
          )
        case .favorite:
          CaseLet(
            /AppScreen.State.favorite,
             action: AppScreen.Action.favorite,
             then: FavoriteView.init
          )
        case .home:
          CaseLet(
            /AppScreen.State.home,
             action: AppScreen.Action.home,
             then: HomeView.init
          )
        case .search:
          CaseLet(
            /AppScreen.State.search,
             action: AppScreen.Action.search,
             then: SearchView.init
          )
        }
      }
    }
  }
}

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
      routes: [.root(.home(.init()), embedInNavigationView: false)]
    )
    
    public static let rootSearchState = AppCoordinator.State(
      routes: [.root(.search(.init()), embedInNavigationView: false)]
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
        state.routes.presentCover(.detail(.init(item: item)))
        
      case .routeAction(_, action: .home(.openFavorite)):
        state.routes.push(.favorite(.init()))
        
      case let .routeAction(_, action: .search(.showDetail(item))):
        state.routes.presentCover(.detail(.init(item: item)))
        
      case .routeAction(_, action: .search(.openFavorite)):
        state.routes.push(.favorite(.init()))
        
      case let .routeAction(_, action: .favorite(.showDetail(item))):
        state.routes.presentCover(.detail(.init(item: item)))
        
      default:
        break
      }
      
      return .none
      
    }.forEachRoute {
      AppScreen()
    }
  }
}
