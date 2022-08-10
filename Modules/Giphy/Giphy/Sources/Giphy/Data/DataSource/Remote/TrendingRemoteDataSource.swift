//
//  TrendingRemoteDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Core
import Combine

public struct TrendingRemoteDataSource: DataSource {
  public typealias Request = Int
  public typealias Response = [Giphy]

  public init() {}

  public func execute(request: Int?) -> AnyPublisher<[Giphy], Error> {
    let result = NetworkService.shared.connect(
      api: APIFactory.trending.url,
      responseType: GiphyResponse.self
    )
    .compactMap { $0.data }
    .eraseToAnyPublisher()

    return result
  }

}
