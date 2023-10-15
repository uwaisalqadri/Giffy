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
          CapsuleTabView(currentTab: viewStore.binding(send: MainTabReducer.Action.selectedTabChanged))
            .padding(.bottom, 20)
        }
      }
    }
  }
}

struct CapsuleTabView: View {
  @Binding var currentTab: Tabs
  
  var body: some View {
    HStack(spacing: 45) {
      ForEach(Tabs.allCases, id: \.rawValue) { tab in
        Button(action: {
          currentTab = tab
        }) {
          VStack {
            Image(systemName: tab.iconName)
              .resizable()
              .foregroundColor(tab.iconColor)
              .frame(width: 28, height: 25, alignment: .center)
              .padding(5)
          }
          .background(
            ZStack {
              if currentTab == tab {
                Color.black.clipShape(Capsule())
                  .frame(width: 90, height: 50)
                  .padding(.horizontal, 30)
                  .transition(currentTab == .home ? .backslide : .slide)
              }
            }
          )
          .animation(.easeInOut, value: tab)
        }
      }
    }
    .frame(maxWidth: 190, minHeight: 65)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .clipShape(Capsule())
    )
    .padding(.horizontal, 70)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView(store: Injection.shared.resolve())
  }
}

extension AnyTransition {
  static var backslide: AnyTransition {
    AnyTransition.asymmetric(
      insertion: .move(edge: .trailing),
      removal: .move(edge: .leading))}
}
