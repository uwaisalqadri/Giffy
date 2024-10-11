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
    let result = try await NetworkService.shared.connect(
      api: APIFactory.search(query: request ?? "").url,
      responseType: GiphyDataResponse.self
    ).data.compactMap { $0.map() } 

    return result
  }
}
