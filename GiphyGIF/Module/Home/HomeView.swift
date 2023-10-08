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
            .font(.system(size: 20, weight: .medium))
            .padding(.leading, 15)
          
          if !viewStore.state.isLoading {
            HStack(alignment: .top) {
              LazyVStack(spacing: 8) {
                ForEach(
                  Array(splitGiphys(items: viewStore.state.list)[0].enumerated()),
                  id: \.offset
                ) { _, item in
                  HomeRow(giphy: item) { selectedItem in
                    viewStore.send(.showDetail(item: selectedItem))
                  }
                  .padding(.horizontal, 5)
                }
              }
              
              LazyVStack(spacing: 8) {
                ForEach(
                  Array(splitGiphys(items: viewStore.state.list)[1].enumerated()),
                  id: \.offset
                ) { _, item in
                  HomeRow(giphy: item) { selectedItem in
                    viewStore.send(.showDetail(item: selectedItem))
                  }
                  .padding(.horizontal, 5)
                }
              }
            }
            
          } else {
            // TODO: Shimmer List
            HStack {
              Spacer()
              ActivityIndicator()
                .padding(.top, 60)
              Spacer()
            }
          }
          
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
            .foregroundColor(.red)
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
  
  private func splitGiphys(items: [Giphy]) -> [[Giphy]] {
    var result: [[Giphy]] = []
    
    var firstGiphys: [Giphy] = []
    var secondGiphys: [Giphy] = []
    
    items.forEach { giphy in
      let index = items.firstIndex {$0.id == giphy.id }
      
      if let index = index {
        if index % 2 == 0 {
          firstGiphys.append(giphy)
        } else {
          secondGiphys.append(giphy)
        }
      }
    }
    
    result.append(firstGiphys)
    result.append(secondGiphys)
    
    return result
  }
  
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(store: Injection.shared.resolve())
  }
}
