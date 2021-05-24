//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct HomeView: View {

  @ObservedObject var viewModel: HomeViewModel

  var body: some View {
    NavigationView {
      if viewModel.loadingState {
        ActivityIndicator()
      } else {
        ScrollView {
          ForEach(viewModel.giphys) { item in
            Text(item.title)
          }
        }.navigationTitle("Trending")
      }
    }.onAppear {
      viewModel.getTrendingGiphy()
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    HomeView(viewModel: assembler.resolve())
  }
}
