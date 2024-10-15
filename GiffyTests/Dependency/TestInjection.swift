//
//  TestInjection.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 11/3/21.
//

@testable import Giffy
@testable import Common
@testable import Core
import Swinject

class TestInjection: Injection {
  private let container = Container()
  
  override init() {
    super.init()
    registerDummyTrendingRemoteDataSource()
    registerDetailFeature()
  }
  
  private func registerDummyTrendingRemoteDataSource() {
    container.register(DummyGetGiphyInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(GetGiphyRepository<DummyRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyRepository(remoteDataSource: self.resolve())
    }
    container.register(DummyRemoteDataSource.self) { _ in
      DummyRemoteDataSource()
    }
  }
  
  private func registerDetailFeature() {
    
    container.register(DetailReducer.self) { _ in
      DetailReducer(checkUseCase: self.resolve(), addUseCase: self.resolve(), removeUseCase: self.resolve())
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
    
    container.register(CheckFavoriteRepository<FavoriteLocalDataSource>.self) { [unowned self] _ in
      CheckFavoriteRepository(localDataSource: self.resolve())
    }
    
    container.register(AddFavoriteRepository<FavoriteLocalDataSource>.self) { [unowned self] _ in
      AddFavoriteRepository(localDataSource: self.resolve())
    }
    
    container.register(RemoveFavoriteRepository<FavoriteLocalDataSource>.self) { [unowned self] _ in
      RemoveFavoriteRepository(localDataSource: self.resolve())
    }
  }
  
  override func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      return super.resolve()
    }
    return result
  }
}
