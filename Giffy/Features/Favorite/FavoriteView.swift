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
                }
              )
              .padding(.horizontal, 16)
              .padding(.bottom, 20)
            }
          }
        }
        .navigationTitle(FavoriteString.titleFavorite.localized)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            IconButton(
              iconName: "chevron.left",
              tint: .blue,
              onClick: {
                viewStore.send(.didBackPressed)
              }
            )
          }
        }
      }
      .onAppear {
        viewStore.send(.fetch())
      }
    }
  }
}

#Preview {
  FavoriteView(store: Injection.resolve())
}
