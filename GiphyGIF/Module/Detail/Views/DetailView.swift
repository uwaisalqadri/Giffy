//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Giphy
import Core

typealias AddFavoritePresenter = GetItemPresenter<
  Giphy, Giphy, Interactor<
    Giphy, Giphy, AddFavoriteRepository<
      GiphyLocalDataSource
    >
  >
>
typealias RemoveFavoritePresenter = GetItemPresenter<
  Giphy, Giphy, Interactor<
    Giphy, Giphy, RemoveFavoriteRepository<
      GiphyLocalDataSource
    >
  >
>


struct DetailView: View {

  @ObservedObject var addFavoritePresenter: AddFavoritePresenter
  @ObservedObject var removeFavoritePresenter: RemoveFavoritePresenter
  @State var isFavorite = false
  let giphy: Giphy

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(trailing:
          Button(action: {
//            if .isFavorite {
//              removeFavoritePresenter.execute(request: giphy)
//              isFavorite.toggle()
//            } else {
//              addFavoritePresenter.execute(request: giphy)
//              isFavorite.toggle()
//            }
            addFavoritePresenter.execute(request: giphy)
          }) {
            Image("heart.fill")
              .resizable()
              .frame(width: 23, height: 20)
              .foregroundColor(.red)
         })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
//    .onAppear {
//      presenter.checkFavorites(idGiphy: giphy.id)
//    }
  }
}
