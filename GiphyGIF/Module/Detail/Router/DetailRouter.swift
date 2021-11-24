//
//  DetailRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/20/21.
//

import SwiftUI
import Giphy

struct DetailRouter {
  func makeDetailView(giphy: Giphy, isFavorite: Bool = false) -> some View {
    return DetailView(
      addFavoritePresenter: Injection.shared.resolve(),
      giphy: giphy
    )
  }
}
