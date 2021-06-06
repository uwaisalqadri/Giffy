//
//  FavoriteView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 26/05/21.
//

import SwiftUI
import Grid

struct FavoriteView: View {

  @ObservedObject var viewModel: FavoriteViewModel
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)

  var body: some View {
    ScrollView {
      LazyVStack {
        Grid(viewModel.giphys, id: \.id) { item in
          HomeItemView(giphy: item)
            .padding(.horizontal, 5)
        }.padding(.bottom, 60)
        .padding(.horizontal, 10)
      }
    }.navigationTitle("Favorite")
    .gridStyle(self.style)
    .onAppear {
      viewModel.getFavorites()
    }
  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    FavoriteView(viewModel: assembler.resolve())
  }
}
