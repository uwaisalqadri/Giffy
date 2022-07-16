//
//  DetailRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/20/21.
//

import SwiftUI
import Giphy

struct DetailRouter {
  let injection: Injection

  func routeDetail(giphy: Giphy, isFavorite: Bool = false) -> some View {
    return DetailView(addFavoritePresenter: injection.resolve(), giphy: giphy)
  }
}
