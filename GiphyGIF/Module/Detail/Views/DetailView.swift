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

typealias CheckFavoritePresenter = GetItemPresenter<
  String, Giphy, Interactor<
    String, Giphy, FavoriteGiphyRepository<
      GiphyLocalDataSource
    >
  >
>

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
  @ObservedObject var favoritePresenter: CheckFavoritePresenter
  @State var giphy: Giphy

  @State private var giphys = [Giphy]()
  @State private var ids = [String]()

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(trailing:
          Button(action: {
            if giphy.isFavorite {
              removeFavoritePresenter.execute(request: giphy)
            } else {
              addFavoritePresenter.execute(request: giphy)
            }
          }) {
            Image(uiImage: loadImage(named: giphy.isFavorite ? "heart.fill" : "heart"))
              .resizable()
              .frame(width: 23, height: 20)
              .foregroundColor(.red)
         })
        .navigationTitle("detail".localized())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
          favoritePresenter.execute(request: giphy.identifier)
          if !favoritePresenter.isLoading {
            giphy.isFavorite = favoritePresenter.item != nil
          }
        }
    }
  }
}
