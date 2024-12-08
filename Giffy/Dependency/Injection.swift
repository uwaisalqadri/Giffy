//
//  Injection.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Swinject
import Core
import CommonUI
import Common
import ComposableArchitecture

public class Injection {
  private let container = Container()

  private init() {
    registerHomeFeature()
    registerDetailFeature()
    registerSearchFeature()
    registerFavoriteFeature()
    registerStickerFeature()
    registerAIGenFeature()
  }

  private func registerHomeFeature() {
    container.register(TrendingUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(GetGiphyInteractor<TrendingRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyInteractor(remoteDataSource: self.resolve())
    }
    container.register(TrendingRemoteDataSource.self) { _ in
      TrendingRemoteDataSource()
    }
  }

  private func registerDetailFeature() {
    container.register(CheckFavoriteUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(AddFavoriteUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(RemoveFavoriteUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(CheckFavoriteInteractor<FavoriteLocalDataSource>.self) { [unowned self] _ in
      CheckFavoriteInteractor(localDataSource: self.resolve())
    }
    container.register(AddFavoriteInteractor<FavoriteLocalDataSource>.self) { [unowned self] _ in
      AddFavoriteInteractor(localDataSource: self.resolve())
    }
    container.register(RemoveFavoriteInteractor<FavoriteLocalDataSource>.self) { [unowned self] _ in
      RemoveFavoriteInteractor(localDataSource: self.resolve())
    }
  }

  private func registerSearchFeature() {
    container.register(SearchUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(SearchGiphyInteractor<SearchRemoteDataSource>.self) { [unowned self] _ in
      SearchGiphyInteractor(remoteDataSource: self.resolve())
    }
    container.register(SearchRemoteDataSource.self) { _ in
      SearchRemoteDataSource()
    }
  }

  private func registerFavoriteFeature() {
    container.register(FavoriteUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(FavoriteGiphysInteractor<FavoriteLocalDataSource>.self) { [unowned self] _ in
      FavoriteGiphysInteractor(localDataSource: self.resolve())
    }
    container.register(FavoriteLocalDataSource.self) { _ in
      FavoriteLocalDataSource()
    }
  }
  
  private func registerStickerFeature() {
    container.register(BackgroundRemovalUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(BackgroundRemovalInteractor<ImageVisionDataSource>.self) { [unowned self] _ in
      BackgroundRemovalInteractor(remoteDataSource: self.resolve())
    }
    container.register(ImageVisionDataSource.self) { _ in
      ImageVisionDataSource()
    }
  }
  
  private func registerAIGenFeature() {
    container.register(AIGenUseCase.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(AIGenInteractor<AIGenDataSource>.self) { [unowned self] _ in
      AIGenInteractor(remoteDataSource: self.resolve())
    }
    container.register(AIGenDataSource.self) { _ in
      AIGenDataSource()
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
