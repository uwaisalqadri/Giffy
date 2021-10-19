//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import Core
import Combine

public struct GiphyRemoteDataSource: DataSource {
  public typealias Request = Int
  public typealias Response = GiphyResponse

  public init() {}

  public func execute(request: Int?) -> AnyPublisher<GiphyResponse, Error> {
    let api: APIFactory
    if request == 0 {
      api = APIFactory.trending
    } else {
      api = APIFactory.random
    }

    let result = NetworkService.shared.connect(
      api: api.url,
      responseType: GiphyResponse.self
    )

    return result.eraseToAnyPublisher()
  }
}
