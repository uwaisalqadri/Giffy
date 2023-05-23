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

struct DetailView: ViewControllable {
  var holder: Common.NavStackHolder

  @ObservedObject var addFavoritePresenter: AddFavoritePresenter
  let giphy: Giphy

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(
          leading: Button(action: {
            guard let viewController = holder.viewController else { return }
            viewController.navigationController?.popViewController(animated: true)
          }) {
            Image("heart")
              .resizable()
              .frame(width: 23, height: 20)
              .foregroundColor(.white)
          },
          trailing: Button(action: {
            addFavoritePresenter.execute(request: giphy)
          }) {
            Image(giphy.isFavorite ? "heart.fill" : "heart", bundle: Bundle.common)
              .resizable()
              .frame(width: 23, height: 20)
              .foregroundColor(.red)
          }
        )
        .navigationTitle("detail".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
