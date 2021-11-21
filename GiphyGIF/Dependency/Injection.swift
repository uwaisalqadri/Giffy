//
//  Injection.swift
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
    registerDetailFeature()
    registerSearchFeature()
    registerFavoriteFeature()
  }

  private func registerHomeFeature() {
    container.register(HomeView.self) { [unowned self] _ in
      HomeView(presenter: self.resolve(), router: self.resolve())
    }

    container.register(HomePresenter.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }

    container.register(
      Interactor<
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

  private func registerDetailFeature() {
    container.register(DetailRouter.self) { _ in
      DetailRouter()
    }

    container.register(CheckFavoritePresenter.self) { [unowned self] _ in
      CheckFavoritePresenter(useCase: self.resolve())
    }

    container.register(AddFavoritePresenter.self) { [unowned self] _ in
      AddFavoritePresenter(useCase: self.resolve())
    }

    container.register(RemoveFavoritePresenter.self) { [unowned self] _ in
      RemoveFavoritePresenter(useCase: self.resolve())
    }

    container.register(
      Interactor<
        String, Giphy, FavoriteGiphyRepository<
          GiphyLocalDataSource
      >
    >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(
      Interactor<
        Giphy, Giphy, AddFavoriteRepository<
          GiphyLocalDataSource
      >
    >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(
      Interactor<
        Giphy, Giphy, RemoveFavoriteRepository<
          GiphyLocalDataSource
      >
    >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(FavoriteGiphyRepository<GiphyLocalDataSource>.self) { [unowned self] _ in
      FavoriteGiphyRepository(localDataSource: self.resolve())
    }

    container.register(AddFavoriteRepository<GiphyLocalDataSource>.self) { [unowned self] _ in
      AddFavoriteRepository(localDataSource: self.resolve())
    }

    container.register(RemoveFavoriteRepository<GiphyLocalDataSource>.self) { [unowned self] _ in
      RemoveFavoriteRepository(localDataSource: self.resolve())
    }
  }

  private func registerSearchFeature() {
    container.register(SearchView.self) { [unowned self] _ in
      SearchView(presenter: self.resolve())
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

  private func registerFavoriteFeature() {
    container.register(FavoriteView.self) { [unowned self] _ in
      FavoriteView(presenter: self.resolve(), removeFavoritePresenter: self.resolve())
    }

    container.register(FavoriteRouter.self) { _ in
      FavoriteRouter()
    }

    container.register(FavoritePresenter.self) { [unowned self] _ in
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
