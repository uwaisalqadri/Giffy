//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Giphy
import Core
import Common

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
  @State var giphy: Giphy

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(trailing:
          Button(action: {
            addFavoritePresenter.execute(request: giphy)
          }) {
            Image(giphy.isFavorite ? "heart.fill" : "heart", bundle: Common.loadBundle())
              .resizable()
              .frame(width: 23, height: 20)
              .foregroundColor(.red)
         })
        .navigationTitle("detail".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
