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

struct MainTabView: View {
  let store: StoreOf<MainTabReducer>
  
  var body: some View {
    WithViewStore(store, observe: \.selectedTab) { viewStore in
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
          TabView(currentTab: viewStore.binding(send: MainTabReducer.Action.selectedTabChanged))
            .padding(.bottom, 20)
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
    MainTabView(store: Injection.shared.resolve())
  }
}
