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
  @ObservedObject var removeFavoritePresenter: RemoveFavoritePresenter
  @ObservedObject var favoritePresenter: FavoritePresenter
  @State var giphy: Giphy

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
            Image(uiImage: CommonImage(named: giphy.isFavorite ? "heart.fill" : "heart"))
              .resizable()
              .frame(width: 23, height: 20)
              .foregroundColor(.red)
         })
        .navigationTitle("detail".localized())
        .navigationBarTitleDisplayMode(.inline)
    }.onAppear {
      checkFavorite(giphyId: giphy.identifier)
      if !favoritePresenter.isLoading {
        print("FAVORITO", favoritePresenter.list)
      }
    }
  }

  private func checkFavorite(giphyId: String) {
    favoritePresenter.getList(request: "")
    favoritePresenter.list.forEach { item in
      ids.append(item.identifier)
      let listId = ids.joined(separator: ",")
      giphy.isFavorite = listId.contains(giphyId)
    }
  }
}
