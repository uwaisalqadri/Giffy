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
  GiphyDataSource.Response == [Giphy],
  GiphyDataSource.Request == Int {

  public typealias Request = Int
  public typealias Response = [Giphy]

  private let remoteDataSource: GiphyDataSource

  public init(remoteDataSource: GiphyDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  public func execute(request: Int?) -> AnyPublisher<[Giphy], Error> {
    return remoteDataSource.execute(request: request)
      .eraseToAnyPublisher()
  }
}
