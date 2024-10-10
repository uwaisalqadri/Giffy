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
import ComposableArchitecture

public class Injection {
  private let container = Container()

  private init() {
    registerHomeFeature()
    registerDetailFeature()
    registerSearchFeature()
    registerFavoriteFeature()
  }

  private func registerHomeFeature() {
    container.register(HomeInteractor.self) { [unowned self] _ in
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
    container.register(CheckFavoriteInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(AddFavoriteInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(RemoveFavoriteInteractor.self) { [unowned self] _ in
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
    container.register(SearchInteractor.self) { [unowned self] _ in
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
    container.register(FavoriteInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(FavoriteGiphysRepository<GiphyLocalDataSource>.self) { [unowned self] _ in
      FavoriteGiphysRepository(localDataSource: self.resolve())
    }
    container.register(GiphyLocalDataSource.self) { _ in
      GiphyLocalDataSource()
    }
  }

  public static func resolve<T>() -> T {
    Injection().resolve()
  }

  public static func resolve<T, A>(argument: A) -> T {
    Injection().resolve(argument: argument)
  }

  public static func resolve<T>(name: String) -> T {
    Injection().resolve(name: name)
  }

  private func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  private func resolve<T, A>(argument: A) -> T {
    guard let result = container.resolve(T.self, argument: argument) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }

  private func resolve<T>(name: String) -> T {
    guard let result = container.resolve(T.self, name: name) else {
      fatalError("This type is not registered: \(T.self)")
    }
    return result
  }
}
