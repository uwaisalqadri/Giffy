//
//  TestInjection.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 11/3/21.
//

@testable import GiphyGIF
@testable import Giphy
@testable import Core
import Swinject

class TestInjection: Injection {
  private let container = Container()

  override init() {
    super.init()
    registerDummyTrendingRemoteDataSource()
    registerActualTrendingRemoteDataSource()
    registerActualSearchRemoteDataSource()
  }

  private func registerDummyTrendingRemoteDataSource() {
    container.register(DummyInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(GetGiphyRepository<DummyRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyRepository(remoteDataSource: self.resolve())
    }
    container.register(DummyRemoteDataSource.self) { _ in
      DummyRemoteDataSource()
    }
  }

  private func registerActualTrendingRemoteDataSource() {
    container.register(ActualTrendingInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(GetGiphyRepository<TrendingRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyRepository(remoteDataSource: self.resolve())
    }

    container.register(TrendingRemoteDataSource.self) { _ in
      TrendingRemoteDataSource()
    }
  }

  private func registerActualSearchRemoteDataSource() {
    container.register(ActualSearchInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }

    container.register(SearchGiphyRepository<SearchRemoteDataSource>.self) { [unowned self] _ in
      SearchGiphyRepository(remoteDataSource: self.resolve())
    }
    container.register(SearchRemoteDataSource.self) { _ in
      SearchRemoteDataSource()
    }
  }

  override func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      return super.resolve()
    }
    return result
  }
}
