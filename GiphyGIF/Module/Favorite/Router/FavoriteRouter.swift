//
//  FavoriteRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/20/21.
//

import SwiftUI

struct FavoriteRouter {
  let injector: Injection

  func routeToFavorite(from viewController: UIViewController) {
    let view = FavoriteView(holder: injector.resolve(), router: injector.resolve(), presenter: injector.resolve(), removeFavoritePresenter: injector.resolve())
    viewController.navigationController?.pushViewController(view.viewController, animated: true)
  }
}
