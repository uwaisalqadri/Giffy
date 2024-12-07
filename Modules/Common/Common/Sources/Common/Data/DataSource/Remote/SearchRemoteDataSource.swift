//
//  SearchDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Core
import Combine

public struct SearchRemoteDataSource: DataSource {
  public typealias Request = String
  public typealias Response = [Giffy]

  public init() {}

  public func execute(request: String?) async throws -> [Giffy] {
    let giphies = try await NetworkService.shared.connect(
      api: GiphyAPI.search(query: request ?? ""),
      responseType: GiphyDataResponse.self
    ).data.compactMap { Giffy(from: $0) }

    let tenors = try await NetworkService.shared.connect(
      api: TenorAPI.search(query: request ?? ""),
      responseType: TenorDataResponse.self
    ).results.compactMap { Giffy(from: $0) }
    
    return giphies + tenors
  }
}
