//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Core

struct DetailView: View {

  @ObservedObject var viewModel: DetailViewModel
  let giphy: Giphy

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(trailing:
          Button(action: {
            viewModel.isFavorite
              ? viewModel.removeFromFavorites(idGiphy: giphy.id)
              : viewModel.addToFavorites(giphy: giphy)
          }) {
            if viewModel.isFavorite {
              Image(systemName: "heart.fill")
               .resizable()
               .frame(width: 23, height: 20)
               .foregroundColor(.red)
            } else {
              Image(systemName: "heart")
               .resizable()
               .frame(width: 23, height: 20)
               .foregroundColor(.red)
            }
         })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
