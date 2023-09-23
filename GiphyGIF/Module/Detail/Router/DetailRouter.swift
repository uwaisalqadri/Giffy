//
//  DetailRouter.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/20/21.
//

import SwiftUI
import Giphy

struct DetailRouter {
  let injector: Injection

  func routeToDetail(from viewController: UIViewController, giphy: Giphy, isFavorite: Bool = false) {
    let view = DetailView(holder: injector.resolve(), store: injector.resolve(), giphy: giphy)
    viewController.present(view.viewController, animated: true)
  }
}
