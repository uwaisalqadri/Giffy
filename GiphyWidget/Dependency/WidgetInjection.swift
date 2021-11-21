//
//  WidgetInjection.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 11/21/21.
//

import Swinject
import Core
import Giphy
import WidgetKit

typealias WidgetPresenter = GetListPresenter<
  String, Giphy, Interactor<
    String, [Giphy], FavoriteGiphysRepository<
      GiphyLocalDataSource
    >
  >
>

class WidgetInjection {
  static let shared = WidgetInjection()
  private let container = Container()

  init() {
    registerFavoriteWidget()
  }

  private func registerFavoriteWidget() {

    container.register(WidgetPresenter.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }

    container.register(
      Interactor<
        String, [Giphy], FavoriteGiphysRepository<
          GiphyLocalDataSource
        >
      >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(FavoriteGiphysRepository<GiphyLocalDataSource>.self) { [unowned self] _ in
      FavoriteGiphysRepository(localDataSource: self.resolve())
    }

    container.register(GiphyLocalDataSource.self) { _ in
      GiphyLocalDataSource()
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
