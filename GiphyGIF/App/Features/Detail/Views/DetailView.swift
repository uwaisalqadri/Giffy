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
  @State var isFavorite = false
  let giphy: Giphy

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(trailing:
          Button(action: {
            if viewModel.isFavorite {
              viewModel.removeFromFavorites(idGiphy: giphy.id)
              isFavorite.toggle()
            } else {
              viewModel.addToFavorites(giphy: giphy)
              isFavorite.toggle()
            }
          }) {
            if isFavorite {
              if !viewModel.isFavorite {
                LottieView(fileName: "when-favorite-clicked", loopMode: .playOnce)
                  .frame(width: 53, height: 50)
              } else {
                LottieView(fileName: "when-unfavorite-clicked", loopMode: .playOnce)
                  .frame(width: 40, height: 50)
              }
            } else if viewModel.isFavorite {
              Image("heart.fill")
                .resizable()
                .frame(width: 23, height: 20)
                .foregroundColor(.red)
            } else {
              Image("heart")
               .resizable()
               .frame(width: 23, height: 20)
               .foregroundColor(.white)
                .padding(.trailing, 15)
            }
         })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }.onAppear {
      viewModel.checkFavorites(idGiphy: giphy.id)
    }
  }
}
