//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Core
import Giphy
import Common
import ComposableArchitecture

struct HomeView: View {
  let store: StoreOf<HomeReducer>
  
  @State private var isFetched = false
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          Text(HomeString.labelTodayPopular.localized)
            .font(.HelveticaNeue.h6HeadingSemibold)
            .padding(.leading, 12)
          
          VStack(alignment: .center) {
            if !viewStore.state.isLoading {
              ZStack {
                LazyVStack {
                  ForEach(Array(viewStore.state.list.enumerated()), id: \.offset) { _, item in
                    GiphyItemRow(
                      isFavorite: item.isFavorite,
                      giphy: item,
                      onTapRow: { item in
                        viewStore.send(.showDetail(item: item))
                      }
                    )
                    .padding(.horizontal, 20)
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
        .padding(.horizontal, 10)
      }
      .navigationTitle(HomeString.titleTrending.localized)
      .navigationViewStyle(.stack)
      .navigationBarItems(
        trailing: Button(action: {
          viewStore.send(.openFavorite)
        }) {
          Image(systemName: "heart.fill")
            .resizable()
            .foregroundColor(.Theme.red)
            .frame(width: 20, height: 18)
        }
      )
      .onAppear {
        if !isFetched {
          isFetched = true
          viewStore.send(.fetch(request: 0))
        }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(store: Injection.shared.resolve())
  }
}
