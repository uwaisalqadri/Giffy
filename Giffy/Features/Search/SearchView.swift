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
  @EnvironmentObject var viewModel: MainTabViewModel
    
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        SearchField { query in
          viewStore.send(.fetch(request: query))
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
      .onChange(of: viewStore.shareImage) { image in
        viewModel.isShowShare = image != nil
      }
      .onAppear {
        viewStore.send(.initialFetch)
      }
    }
  }
}

#Preview {
  SearchView(store: Injection.resolve())
}
