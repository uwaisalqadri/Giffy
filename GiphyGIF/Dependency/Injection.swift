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
      HomeView(store: self.resolve())
    }
    
    container.register(StoreOf<HomeReducer>.self) { _ in
      Store(initialState: HomeReducer.State(), reducer: {
        HomeReducer(useCase: self.resolve(), checkUseCase: self.resolve(), addUseCase: self.resolve(), removeUseCase: self.resolve())
      })
    }
    
    container.register(StoreOf<MainTabReducer>.self) { _ in
      Store(initialState: MainTabReducer.State(), reducer: {
        MainTabReducer()
      })
    }

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
    
    container.register(StoreOf<DetailReducer>.self) { _ in
      Store(initialState: DetailReducer.State(item: .init()), reducer: {
        DetailReducer(checkUseCase: self.resolve(), addUseCase: self.resolve(), removeUseCase: self.resolve())
      })
    }

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
    container.register(SearchView.self) { [unowned self] _ in
      SearchView(store: self.resolve())
    }
    
    container.register(StoreOf<SearchReducer>.self) { [unowned self] _ in
      Store(initialState: SearchReducer.State()) {
        SearchReducer(useCase: self.resolve())
      }
    }
    
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
    container.register(FavoriteView.self) { [unowned self] _ in
      FavoriteView(store: self.resolve())
    }
    
    container.register(StoreOf<FavoriteReducer>.self) { [unowned self] _ in
      Store(initialState: FavoriteReducer.State()) {
        FavoriteReducer(useCase: self.resolve(), removeUseCase: self.resolve())
      }
    }
    
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
