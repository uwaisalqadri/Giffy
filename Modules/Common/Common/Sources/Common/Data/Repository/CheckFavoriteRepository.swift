//
//  CheckFavoriteRepository.swift
//  
//
//  Created by Uwais Alqadri on 21/9/23.
//

import Foundation
import Core
import Combine

public struct CheckFavoriteRepository<
  GiphyDataSource: LocalDataSource>: Repository
where
  GiphyDataSource.Response == Giphy,
  GiphyDataSource.Request == String {

  public typealias Request = String
  public typealias Response = Bool

  private let localDataSource: GiphyDataSource

  public init(localDataSource: GiphyDataSource) {
    self.localDataSource = localDataSource
  }

  public func execute(request: String?) async throws -> Bool {
    return try await localDataSource.isFavorited(id: request ?? "")
  }
}
