//
//  ContentView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import Common
import CommonUI
import ComposableArchitecture
import Combine

class MainTabViewModel: ObservableObject {
  @Published var isShowShare = false
}

struct MainTabView: View {
  let store: StoreOf<MainTabReducer>
  @StateObject var viewModel = MainTabViewModel()

  var body: some View {
    WithViewStore(store, observe: \.selectedTab) { viewStore in
      NavigationView {
        ZStack {
          switch viewStore.state {
          case .home:
            HomeView(
              store: store.scope(
                state: \.home,
                action: \.home
              )
            )
            
          case .search:
            SearchView(
              store: store.scope(
                state: \.search,
                action: \.search
              )
            )
            
          case .sticker:
            StickerView(
              store: store.scope(
                state: \.sticker,
                action: \.sticker
              )
            )
            
          case .aiGen:
            AIGenView(
              store: store.scope(
                state: \.aiGen,
                action: \.aiGen
              )
            )
          }
          
          if !viewModel.isShowShare {
            VStack {
              Spacer()
              CapsuleTabView(
                currentTab: viewStore.binding(
                  send: MainTabReducer.Action.selectedTabChanged
                )
              ).padding(.bottom, 20)
            }
          }
        }
        .animation(.easeInOut(duration: 0.2), value: viewStore.state)
      }.environmentObject(viewModel)
    }
  }
}

struct CapsuleTabView: View {
  @Binding var currentTab: Tabs

  var body: some View {
    HStack(spacing: 20) {
      ForEach(Tabs.allCases, id: \.rawValue) { tab in
        Button(action: {
          currentTab = tab
        }) {
          VStack {
            Image(systemName: tab.iconName)
              .foregroundColor(tab.iconColor)
              .font(.system(size: 20))
              .padding(5)
          }
          .background(
            ZStack {
              if currentTab == tab {
                Color.black.clipShape(.circle)
                  .frame(width: 50, height: 50)
                  .padding(.horizontal, 32)
              }
            }
          )
          .animation(.easeInOut, value: tab)
        }
      }
    }
    .frame(minHeight: 65)
    .padding(.horizontal, 16)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .clipShape(.capsule)
    )
  }
}

extension AnyTransition {
  static var backslide: AnyTransition {
    AnyTransition.asymmetric(
      insertion: .move(edge: .trailing),
      removal: .move(edge: .leading))
  }
}
