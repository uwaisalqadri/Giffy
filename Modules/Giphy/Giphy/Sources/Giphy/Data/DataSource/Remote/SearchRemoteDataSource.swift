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
  public typealias Response = GiphyResponse

  public init() {}

  public func execute(request: String?) -> AnyPublisher<GiphyResponse, Error> {
    let result = NetworkService.shared.connect(
      api: APIFactory.search(query: request ?? "").url,
      responseType: GiphyResponse.self
    )

    return result.eraseToAnyPublisher()
  }
}
