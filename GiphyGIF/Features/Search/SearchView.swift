//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Lottie
import Core
import Giphy
import Common
import ComposableArchitecture

struct SearchView: View {
  let store: StoreOf<SearchReducer>
  
  @State private var searchText = ""
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        SearchField { query in
          searchText = query
          viewStore.send(.fetch(request: searchText))
        }
        
        if !viewStore.state.isLoading {
          if viewStore.state.grid.rightGrid.isEmpty {
            SearchEmptyView()
              .padding(.top, 30)
          }
          
          HStack(alignment: .top) {
            LazyVStack(spacing: 8) {
              ForEach(viewStore.state.grid.rightGrid.indexed, id: \.position) { _, item in
                GiphyGridRow(giphy: item) { selectedItem in
                  viewStore.send(.showDetail(item: selectedItem))
                }
                .padding(.horizontal, 5)
              }
            }
            
            LazyVStack(spacing: 8) {
              ForEach(viewStore.state.grid.leftGrid.indexed, id: \.position) { _, item in
                GiphyGridRow(giphy: item) { selectedItem in
                  viewStore.send(.showDetail(item: selectedItem))
                }
                .padding(.horizontal, 5)
              }
            }
          }.padding(.horizontal, 10)
          
        } else {
          NyanCatLoading()
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        }
      }
      .navigationTitle(SearchString.titleSearch.localized)
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
      .padding(.top, 10)
      .onAppear {
        viewStore.send(.fetch(request: searchText.isEmpty ? "Hello" : searchText))
      }
    }
  }
}

#Preview {
  SearchView(store: Injection.resolve())
}
