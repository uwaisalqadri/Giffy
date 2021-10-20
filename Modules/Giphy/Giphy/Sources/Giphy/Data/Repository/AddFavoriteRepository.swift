//
//  AddFavoriteRepository.swift
//  
//
//  Created by Uwais Alqadri on 10/20/21.
//

import Foundation
import Core
import Combine

public struct AddFavoriteRepository<
  GiphyDataSource: LocalDataSource>: Repository
where
  GiphyDataSource.Response == Giphy,
  GiphyDataSource.Request == String {

  public typealias Request = Giphy
  public typealias Response = Giphy

  private let localDataSource: GiphyDataSource

  public init(localDataSource: GiphyDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: Giphy?) -> AnyPublisher<Giphy, Error> {
    return Future<Giphy, Error> { completion in
      if let giphy = request {
        _ = localDataSource.add(entity: giphy)
        completion(.success(giphy))
      }
    }.eraseToAnyPublisher()
  }
}
