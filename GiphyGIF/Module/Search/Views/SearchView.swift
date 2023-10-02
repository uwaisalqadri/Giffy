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
        SearchInput { query in
          viewStore.send(.fetch(request: query))
        }
        
        if !viewStore.state.isLoading {
          if !viewStore.state.list.isEmpty {
            ZStack {
              LazyVStack {
                ForEach(Array(viewStore.state.list.enumerated()), id: \.offset) { _, item in
                  SearchRow(giphy: item, onTapRow: { giphy in
                    viewStore.send(.showDetail(item: giphy))
                  })
                  .padding(.horizontal, 20)
                  .padding(.bottom, 20)
                }
              }.padding(.top, 20)
            }
          } else {
            SearchEmptyView()
              .padding(.top, 30)
          }
        } else {
          ActivityIndicator()
            .padding(.top, 10)
        }
      }.navigationTitle(SearchString.titleSearch.localized)
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
        .navigationViewStyle(StackNavigationViewStyle())
        .padding(.top, 10)
        .onAppear {
          viewStore.send(.fetch(request: "Hello"))
        }
    }  }
}

struct SearchInput: View {
  
  @State private var query = ""
  var onQueryChange: ((String) -> Void)?
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "magnifyingglass")
          .resizable()
          .foregroundColor(.white)
          .frame(width: 20, height: 20)
          .padding(.leading, 30)
        
        TextField(SearchString.labelSearchDesc.localized, text: $query, onCommit: {
          onQueryChange?(query)
        })
        .foregroundColor(.white)
        .font(.system(size: UIDevice.isIpad ? 20 : 16))
        .frame(height: UIDevice.isIpad ? 60 : 40)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .padding(.leading, 13)
        .padding(.trailing, 30)
        .onChange(of: query) { text in
          onQueryChange?(text)
        }
        
      }
      .background(Color.init(.systemGray6))
      .cornerRadius(20)
      .padding(.horizontal, 20)
    }
  }
}

struct SearchEmptyView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "search_empty", bundle: Bundle.common, loopMode: .loop)
        .frame(width: 200, height: 200)
        .padding(.bottom, 5)
      
      Text(SearchString.labelSearching.localized)
        .padding(.horizontal, 40)
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(store: Injection.shared.resolve())
  }
}
