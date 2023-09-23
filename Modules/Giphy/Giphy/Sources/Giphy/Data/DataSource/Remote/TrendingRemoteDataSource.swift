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

  public func execute(request: Int?) async throws -> [Giphy] {
    let result = try await NetworkService.shared.connect(
      api: APIFactory.trending.url,
      responseType: GiphyDataResponse.self
    ).data?.compactMap { $0.map() } ?? []

    return result
  }

}
