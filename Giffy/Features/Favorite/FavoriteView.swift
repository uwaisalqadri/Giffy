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
  @Environment(\.dismiss) var pop
  let store: StoreOf<FavoriteReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        ScrollView(.vertical, showsIndicators: false) {
          SearchField { query in
            viewStore.send(.fetch(request: query))
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 20)
          .padding(.top, 52)
          
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
        
        VStack {
          FavoriteToolbar(title: Localizable.titleFavorite.tr()) {
            pop()
          }
          Spacer()
        }
      }
    }
  }
}

struct FavoriteToolbar: View {
  var title: String
  var onBackPressed: () -> Void
  
  var body: some View {
    HStack {
      IconButton(
        iconName: "chevron.left",
        tint: .Theme.red,
        size: 26,
        onClick: onBackPressed
      )
      Spacer()
      Text(title)
        .font(.system(size: 16, weight: .bold))
      Spacer()
      Spacer().frame(width: 32)
    }
    .padding([.horizontal, .bottom], 8)
    .background(Blur(style: .prominent).edgesIgnoringSafeArea(.top))
  }
}

#Preview {
  FavoriteView(store: Injection.resolve())
}
