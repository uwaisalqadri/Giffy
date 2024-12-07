//
//  WidgetInjection.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 11/21/21.
//

import Swinject
import Core
import Common
import WidgetKit

class WidgetInjection {
  static let shared = WidgetInjection()
  private let container = Container()

  init() {
    registerFavoriteWidget()
  }

  private func registerFavoriteWidget() {
    container.register(FavoriteWidgetUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(FavoriteGiphysInteractor<FavoriteLocalDataSource>.self) { [unowned self] _ in
      FavoriteGiphysInteractor(localDataSource: self.resolve())
    }

    container.register(FavoriteLocalDataSource.self) { _ in
      FavoriteLocalDataSource()
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
