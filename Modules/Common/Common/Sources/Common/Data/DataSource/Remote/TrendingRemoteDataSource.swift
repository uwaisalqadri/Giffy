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
    ).data.compactMap { Giffy(from: $0) }
    
    let tenors = try await NetworkService.shared.connect(
      api: TenorAPI.search(query: "", limit: 18),
      responseType: TenorDataResponse.self
    ).results.compactMap { Giffy(from: $0) }

    return giphies + tenors
      .filter { !$0.title.isEmpty }
  }

}
