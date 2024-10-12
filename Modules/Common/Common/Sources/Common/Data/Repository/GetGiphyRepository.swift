//
//  GetGiphyRepository.swift
//  
//
//  Created by Uwais Alqadri on 10/19/21.
//

import Core
import Combine

public struct GetGiphyRepository<
  GiphyDataSource: DataSource>: Repository
where
  GiphyDataSource.Response == [Giffy],
  GiphyDataSource.Request == Int {

  public typealias Request = Int
  public typealias Response = [Giffy]

  private let remoteDataSource: GiphyDataSource

  public init(remoteDataSource: GiphyDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  public func execute(request: Int?) async throws -> [Giffy] {
    return try await remoteDataSource.execute(request: request)
  }
}
