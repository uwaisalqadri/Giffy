//
//  RemoveFavoriteRepository.swift
//  
//
//  Created by Uwais Alqadri on 10/20/21.
//

import Foundation
import Core
import Combine

public struct RemoveFavoriteRepository<
  GiphyDataSource: LocalDataSource>: Repository
where
  GiphyDataSource.Response == Giphy,
  GiphyDataSource.Request == String {

  public typealias Request = Giphy
  public typealias Response = Bool

  private let localDataSource: GiphyDataSource

  public init(localDataSource: GiphyDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: Giphy?) -> AnyPublisher<Bool, Error> {
    return localDataSource.delete(id: request?.id ?? "")
      .eraseToAnyPublisher()
  }
}
