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
  public typealias Response = [Giffy]

  public init() {}

  public func execute(request: Int?) async throws -> [Giffy] {
    let giphies = try await NetworkService.shared.connect(
      api: GiphyAPI.trending,
      responseType: GiphyDataResponse.self
    ).data.compactMap { $0.map() }
    
    let tenors = try await NetworkService.shared.connect(
      api: TenorAPI.search(query: "trending", limit: 18),
      responseType: TenorDataResponse.self
    ).results.compactMap { $0.map() }

    return combineGiffies(giphies, tenors)
      .filter { !$0.title.isEmpty }
  }

}
