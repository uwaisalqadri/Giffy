//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Core
import Common
import CommonUI
import ComposableArchitecture

struct HomeView: View {
  let store: StoreOf<HomeReducer>
    
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          VStack(alignment: .center) {
            if !viewStore.state.isLoading {
              ZStack {
                LazyVStack {
                  ForEach(viewStore.state.list.indexed, id: \.position) { _, item in
                    GiffyRow(
                      isFavorite: item.isFavorite,
                      giphy: item,
                      onTapRow: { item in
                        viewStore.send(.showDetail(item: item))
                      }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                  }
                }.padding(.top, 20)
              }
              
            } else {
              NyanCatLoading()
                .padding(.top, 40)
            }
          }.frame(maxWidth: .infinity)
          
        }
        .padding(.bottom, 60)
      }
      .navigationViewStyle(.stack)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          VStack(alignment: .leading) {
            Text(HomeString.labelTodayPopular.localized)
              .font(.bold, size: 22)
          }.padding(.top, 5)
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
      .onAppear {
        viewStore.send(.fetch(request: 0))
      }
    }
  }
}

#Preview {
  HomeView(store: Injection.resolve())
}
