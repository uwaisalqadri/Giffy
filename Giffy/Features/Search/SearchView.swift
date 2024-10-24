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
                  GiffyGridRow(giphy: item) { selectedItem in
                    viewStore.send(.showDetail(item: selectedItem))
                  }
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
      .navigationTitle(SearchString.titleSearch.localized)
      .navigationViewStyle(.stack)
      .navigationBarItems(
        trailing: IconButton(
          iconName: "heart",
          tint: .Theme.red,
          onClick: {
            viewStore.send(.openFavorite)
          }
        ).tapScaleEffect()
      )
      .padding(.top, 10)
      .onAppear {
        let searchText = viewStore.state.searchText
        viewStore.send(.fetch(
          request: searchText.isEmpty ? "Hello" : searchText
        ))
      }
      .trackScrollOffset { offset in
        if offset > 4 {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      }
    }
  }
}

#Preview {
  SearchView(store: Injection.resolve())
}
