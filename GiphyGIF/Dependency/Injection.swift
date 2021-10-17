//
//  AppAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Swinject
import Core
import Giphy

class Injection {
  static let shared = Injection()
  private let container = Container()

  init() {
    registerSearchFeature()
  }

  private func registerSearchFeature() {
    container.register(SearchView.self) { [unowned self] _ in
      SearchView(
        presenter: self.resolve()
      )
    }
    container.register(SearchPresenter.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }
    container.register(
      Interactor<
        String, [Giphy], GiphyRepository<
          SearchRemoteDataSource
        >
      >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(GiphyRepository<SearchRemoteDataSource>.self) { [unowned self] _ in
      GiphyRepository(remoteDataSource: self.resolve())
    }
    container.register(SearchRemoteDataSource.self) { _ in
      SearchRemoteDataSource()
    }
  }

  func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  func resolve<T, A>(argument: A) -> T {
    guard let result = container.resolve(T.self, argument: argument) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
  func resolve<T>(name: String) -> T {
    guard let result = container.resolve(T.self, name: name) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
