//
//  ContentView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import Common
import ComposableArchitecture
import TCACoordinators

public enum Tabs: Int {
  case home
  case search
}

struct AppReducer: Reducer {
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

struct ContentView: View {
  let store: StoreOf<AppReducer>
  
  var body: some View {
    WithViewStore(self.store, observe: \.selectedTab) { viewStore in
      ZStack {
        switch viewStore.state {
        case .home:
          AppCoordinatorView(
            coordinator: store.scope(
              state: \.homeTab,
              action: { .homeTab($0) }
            )
          )
        case .search:
          AppCoordinatorView(
            coordinator: store.scope(
              state: \.searchTab,
              action: { .searchTab($0) }
            )
          )
        }

        VStack {
          Spacer()
          TabView(currentTab: viewStore.binding(send: AppReducer.Action.selectedTabChanged))
            .padding(.bottom, 20)
        }
      }
    }
  }
}

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

struct TabView: View {
  @Binding var currentTab: Tabs
  
  var body: some View {
    HStack(spacing: 30) {
      Button(action: {
        currentTab = .home
      }) {
        VStack {
          Image(systemName: "rectangle.3.offgrid")
            .resizable()
            .foregroundColor(.green)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }

      Button(action: {
        currentTab = .search
      }) {
        VStack {
          Image(systemName: "rectangle.stack")
            .resizable()
            .foregroundColor(.yellow)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }

//      Button(action: {
//        currentTab = 2
//      }) {
//        VStack {
//          Image(systemName: "person")
//            .resizable()
//            .foregroundColor(.purple)
//            .frame(width: 25, height: 25, alignment: .center)
//            .padding(5)
//        }
//      }
    }
    .frame(maxWidth: UIDevice.isIpad ? 300 : .infinity, minHeight: 80)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .cornerRadius(15, corners: [.allCorners])
    )
    .padding(.horizontal, 70)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(store: Injection.shared.resolve())
  }
}
