//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Lottie
import Core
import CommonUI
import Common
import ComposableArchitecture

struct SearchView: View {
  let store: StoreOf<SearchReducer>
  @EnvironmentObject var tabState: MainTabStateHolder
    
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        SearchField(initialQuery: tabState.searchQuery) { query in
          tabState.searchQuery = query
          viewStore.send(.fetch(request: query))
        } onPaste: { string, gifData in
          if let string {
            tabState.searchQuery = string
            viewStore.send(.fetch(request: string))
          } else if let gifData {
            viewStore.send(.onGIFPasted(data: gifData))
          }
        }.padding(.horizontal, 16)

        if !viewStore.state.isLoading {
          if viewStore.state.isEmpty {
            SearchEmptyView()
              .padding(.top, 30)
          }
          
          HStack(alignment: .top) {
            ForEach(SearchReducer.GridSide.allCases, id: \.self) { side in
              let currentItems = viewStore.state.items(side)
              LazyVStack(spacing: 8) {
                ForEach(currentItems.indexed, id: \.position) { _, item in
                  GiffyGridRow(
                    giphy: item,
                    onTapRow: { selectedItem in
                      viewStore.send(.showDetail(item: selectedItem))
                    },
                    onShare: { image in
                      viewStore.send(.showShare(image))
                    }
                  )
                  .padding(.horizontal, 5)
                }
              }
            }
          }.padding(.horizontal, 10)
          
        } else {
          NyanCatLoading()
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        }
      }
      .scrollDismissesKeyboard(.immediately)
      .navigationViewStyle(.stack)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Text(key: .titleSearch)
            .font(.bold, size: 22)
        }

        ToolbarItem(placement: .topBarTrailing) {
          IconButton(
            iconName: "heart",
            tint: .Theme.red,
            onClick: {
              viewStore.send(.openFavorite)
            }
          ).tapScaleEffect()
        }
      }
      .showDialog(
        shouldDismissOnTapOutside: true,
        isShowing: viewStore.binding(
          get: { $0.shareImage != nil },
          send: .showShare(nil)
        )
      ) {
        ShareView(store: viewStore.share)
      }
      .onChange(of: viewStore.shareImage) { _, image in
        tabState.isShowShare = image != nil
      }
      .onAppear {
        if tabState.searchQuery.isEmpty {
          viewStore.send(.initialFetch)
        } else {
          viewStore.send(.fetch(request: tabState.searchQuery))
        }
      }
    }
  }
}

#Preview {
  SearchView(store: Injection.resolve())
}
