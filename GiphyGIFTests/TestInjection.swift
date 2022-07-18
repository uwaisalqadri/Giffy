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
    registerTrendingRemoteDataSource()
  }

  private func registerTrendingRemoteDataSource() {
    container.register(DummyTrendingInteractor.self) { [unowned self] _ in
      Interactor(repository: self.resolve())
    }
    container.register(GetGiphyRepository<DummyTrendingRemoteDataSource>.self) { [unowned self] _ in
      GetGiphyRepository(remoteDataSource: self.resolve())
    }
    container.register(DummyTrendingRemoteDataSource.self) { _ in
      DummyTrendingRemoteDataSource()
    }
  }

  override func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      return super.resolve()
    }
    return result
  }
}
