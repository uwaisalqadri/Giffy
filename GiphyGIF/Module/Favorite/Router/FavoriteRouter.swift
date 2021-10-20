//
//  FavoriteRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/20/21.
//

import SwiftUI

struct FavoriteRouter {
  func makeFavoriteView() -> some View {
    return FavoriteView(presenter: Injection.shared.resolve())
  }
}
