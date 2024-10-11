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
  public typealias Response = [Giphy]

  public init() {}

  public func execute(request: String?) async throws -> [Giphy] {
    let giphyResult = try await NetworkService.shared.connect(
      api: GiphyAPI.search(query: request ?? ""),
      responseType: GiphyDataResponse.self
    ).data.compactMap { $0.map() } 

//    let tenorResult = try await NetworkService.shared.connect(
//      api: TenorAPI.search(query: request ?? ""),
//      responseType: GiphyDataResponse.self
//    ).data.compactMap { $0.map() }

    return giphyResult
  }
}
