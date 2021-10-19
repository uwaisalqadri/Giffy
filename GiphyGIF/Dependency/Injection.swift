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
    registerHomeFeature()
    registerSearchFeature()
  }

  private func registerHomeFeature() {
    container.register(HomeView.self) { [unowned self] _ in
      HomeView(presenter: self.resolve())
    }

    container.register(HomePresenter.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }

    container.register(Interactor<
      Int, [Giphy], GetGiphyRepository<
        GiphyRemoteDataSource
      >
    >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(GetGiphyRepository<GiphyRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyRepository(remoteDataSource: self.resolve())
    }

    container.register(GiphyRemoteDataSource.self) { _ in
      GiphyRemoteDataSource()
    }
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
        String, [Giphy], SearchGiphyRepository<
          SearchRemoteDataSource
        >
      >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(SearchGiphyRepository<SearchRemoteDataSource>.self) { [unowned self] _ in
      SearchGiphyRepository(remoteDataSource: self.resolve())
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
