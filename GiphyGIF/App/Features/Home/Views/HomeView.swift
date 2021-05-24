//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Grid

struct HomeView: View {

  @ObservedObject var viewModel: HomeViewModel
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)

  var body: some View {
    NavigationView {
      if viewModel.loadingState {
        ActivityIndicator()
      } else {
        ScrollView {
          Grid(viewModel.giphys, id: \.id) { item in
            GiphyRow(giphy: item)
              .padding([.leading, .trailing], 10)
          }
        }.navigationTitle("Trending")
        .gridStyle(self.style)
      }
    }.onAppear {
      viewModel.getTrendingGiphy()
      print(viewModel.giphys)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    HomeView(viewModel: assembler.resolve())
  }
}
