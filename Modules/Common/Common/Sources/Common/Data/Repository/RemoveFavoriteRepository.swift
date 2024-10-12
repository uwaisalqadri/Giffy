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
  GiphyDataSource.Response == Giffy,
  GiphyDataSource.Request == String {

  public typealias Request = Giffy
  public typealias Response = Bool

  private let localDataSource: GiphyDataSource

  public init(localDataSource: GiphyDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: Giffy?) async throws -> Bool {
    return try await localDataSource.delete(id: request?.id ?? "")
  }
}
