//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct SearchView: View {

  @ObservedObject var viewModel: SearchViewModel

  var body: some View {
    if viewModel.loadingState {
      ActivityIndicator()
    } else {
      NavigationView {
        ScrollView {
          ForEach(viewModel.giphys) { item in
            Text("Search View")
          }.navigationTitle("Search")
        }
      }.onAppear {
        viewModel.getSearchGiphy(query: "naruto")
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
