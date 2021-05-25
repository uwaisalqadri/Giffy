//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct SearchView: View {

  @ObservedObject var viewModel: SearchViewModel
  @State var searchText = ""

  var body: some View {
    NavigationView {
      ScrollView {
        searchInput
        if !viewModel.loadingState {
          ForEach(viewModel.giphys) { item in
            SearchItemView(giphy: item)
              .padding([.leading, .trailing], 10)
          }.padding(.top, 10)
        } else {
          ActivityIndicator()
            .padding(.top, 10)
        }
      }.navigationTitle("Search")
      .padding(.top, 10)
    }
  }
}

extension SearchView {

  var searchInput: some View {
    VStack(alignment: .leading) {

      HStack {
        TextField("Search giphy..", text: $viewModel.searchText)
          .font(.system(size: 18, weight: .medium))
          .padding(.horizontal, 20)
          .frame(height: 40)
          .background(
            ZStack(alignment: .trailing) {
              RoundedRectangle(cornerRadius: 7)
                .fill(Color(.systemGray6))

              Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray2))
                .padding(.trailing, 13)
            }
          ).padding(.horizontal, 10)
      }
    }
  }
}


struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    SearchView(viewModel: assembler.resolve())
  }
}
