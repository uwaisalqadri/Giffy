//
//  SearchRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/5/23.
//

import SwiftUI
import Giphy

struct SearchRouter {
  let injector: Injection

  func routeToFavorite(from viewController: UIViewController) {
    let router: FavoriteRouter = injector.resolve()
    router.routeToFavorite(from: viewController)
  }
  
  func routeToDetail(from viewController: UIViewController, giphy: Giphy) {
    let router: DetailRouter = injector.resolve()
    router.routeToDetail(from: viewController, giphy: giphy)
  }
}
