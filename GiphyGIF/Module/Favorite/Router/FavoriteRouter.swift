//
//  FavoriteRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/20/21.
//

import SwiftUI

struct FavoriteRouter {
  let injection: Injection

  func routeFavorite() -> some View {
    return FavoriteView(presenter: injection.resolve(), removeFavoritePresenter: injection.resolve())
  }
}
