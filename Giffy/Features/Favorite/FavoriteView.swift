//
//  FavoriteView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 26/05/21.
//

import SwiftUI
import Lottie
import Core
import Common
import CommonUI
import ComposableArchitecture

struct FavoriteView: View {
  let store: StoreOf<FavoriteReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        ScrollView(.vertical, showsIndicators: false) {
          SearchField { query in
            viewStore.send(.fetch(request: query))
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 20)

          if viewStore.state.list.isEmpty {
            FavoriteEmptyView()
              .padding(.top, 50)
          }
          
          LazyVStack {
            ForEach(viewStore.state.list, id: \.id) { item in
              GiffyRow(
                isFavorite: true,
                giphy: item,
                onTapRow: { giphy in
                  viewStore.send(.showDetail(item: giphy))
                },
                onFavorite: { giphy in
                  viewStore.send(.removeFavorite(item: giphy, request: ""))
                },
                onShare: { image in
                  viewStore.send(.showShare(image))
                }
              )
              .padding(.horizontal, 16)
              .padding(.bottom, 20)
            }
          }
        }
        .scrollDismissesKeyboard(.immediately)
        .animation(.easeInOut(duration: 0.2), value: viewStore.list.count)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            IconButton(
              iconName: "chevron.left",
              tint: .blue,
              onClick: {
                viewStore.send(.didBackPressed)
              }
            )
          }
          
          ToolbarItem(placement: .principal) {
            Text(key: .titleFavorite)
              .font(.bold, size: 16)
          }
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
      .onAppear {
        viewStore.send(.fetch())
      }
      .onReceive(viewStore.state.detailDisappear) { _ in
        viewStore.send(.fetch())
      }
    }
  }
}

#Preview {
  FavoriteView(store: Injection.resolve())
}
