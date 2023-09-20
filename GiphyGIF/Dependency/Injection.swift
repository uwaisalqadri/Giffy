//
//  Injection.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Swinject
import Core
import Giphy
import Common

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
      HomeView(holder: self.resolve(), presenter: self.resolve(), router: self.resolve())
    }
    
    container.register(AboutView.self) { [unowned self] _ in
      AboutView(holder: self.resolve())
    }
    
    container.register(HomeRouter.self) { _ in
      HomeRouter(injector: self)
    }

    container.register(HomePresenter.self) { [unowned self] _ in
      GetListPresenter(useCase: self.resolve())
    }

    container.register(
      Interactor<
        Int, [Giphy], GetGiphyRepository<
          TrendingRemoteDataSource
      >
    >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(GetGiphyRepository<TrendingRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyRepository(remoteDataSource: self.resolve())
    }

    container.register(TrendingRemoteDataSource.self) { _ in
      TrendingRemoteDataSource()
    }
  }

  private func registerDetailFeature() {
    container.register(DetailRouter.self) { _ in
      DetailRouter(injector: self)
    }

    container.register(AddFavoritePresenter.self) { [unowned self] _ in
      AddFavoritePresenter(useCase: self.resolve())
    }

    container.register(RemoveFavoritePresenter.self) { [unowned self] _ in
      RemoveFavoritePresenter(useCase: self.resolve())
    }

    container.register(
      Interactor<
        String, Bool, CheckFavoriteRepository<
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
        Giphy, Bool, RemoveFavoriteRepository<
          GiphyLocalDataSource
      >
    >.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(CheckFavoriteRepository<GiphyLocalDataSource>.self) { [unowned self] _ in
      CheckFavoriteRepository(localDataSource: self.resolve())
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
      SearchView(holder: self.resolve(), router: self.resolve(), presenter: self.resolve())
    }
    container.register(SearchRouter.self) { _ in
      SearchRouter(injector: self)
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
      FavoriteView(holder: self.resolve(), router: self.resolve(), presenter: self.resolve(), removeFavoritePresenter: self.resolve())
    }

    container.register(FavoriteRouter.self) { _ in
      FavoriteRouter(injector: self)
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
    
    container.register(NavStackHolder.self) { _ in
      Common.NavStackHolder()
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
