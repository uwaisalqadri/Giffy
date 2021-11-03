//
//  DummyInjection.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 11/3/21.
//

@testable import GiphyGIF
@testable import Giphy
@testable import Core
import Swinject

class DummyInjection: Injection {
  private let container = Container()

  override init() {
    super.init()
    registerDummyDataSource()
  }

  private func registerDummyDataSource() {
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

  override func resolve<T>() -> T {
    guard let result = container.resolve(T.self) else {
      return super.resolve()
    }
    return result
  }
}
