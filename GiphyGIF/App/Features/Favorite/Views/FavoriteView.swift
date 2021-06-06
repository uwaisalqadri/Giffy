//
//  FavoriteView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 26/05/21.
//

import SwiftUI
import Grid
import Lottie

struct FavoriteView: View {

  @ObservedObject var viewModel: FavoriteViewModel
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)

  var body: some View {
    ScrollView {
      LazyVStack {
        if !viewModel.giphys.isEmpty {
          Grid(viewModel.giphys, id: \.id) { item in
            HomeItemView(giphy: item)
              .padding(.horizontal, 5)
          }.padding(.bottom, 60)
          .padding(.horizontal, 10)
        } else {
          isFavoriteEmpty.padding(.top, 50)
        }
      }
    }.navigationTitle("Favorite")
    .gridStyle(self.style)
    .onAppear {
      viewModel.getFavorites()
    }
  }

  var isFavoriteEmpty: some View {
    VStack {
      LottieView(fileName: "favorite-empty", loopMode: .loop)
        .frame(width: 220, height: 220)
    }
  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    FavoriteView(viewModel: assembler.resolve())
  }
}
