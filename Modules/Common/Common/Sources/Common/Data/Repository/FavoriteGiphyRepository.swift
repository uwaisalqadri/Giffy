//
//  FavoriteGiphyRepository.swift
//  
//
//  Created by Uwais Alqadri on 10/20/21.
//

import Foundation
import Core
import Combine

public struct FavoriteGiphysRepository<
  GiphyDataSource: LocalDataSource>: Repository
where
  GiphyDataSource.Response == Giphy,
  GiphyDataSource.Request == String {

  public typealias Request = String
  public typealias Response = [Giphy]

  private let localDataSource: GiphyDataSource

  public init(localDataSource: GiphyDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: String?) async throws -> [Giphy] {
    return try await localDataSource.list(request: request)
  }
}
