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
  public typealias Response = [Giphy]

  public init() {}

  public func execute(request: Int?) -> AnyPublisher<[Giphy], Error> {
    let api = request == 0 ? APIFactory.trending : APIFactory.random
    let result = NetworkService.shared.connect(
      api: api.url,
      responseType: GiphyResponse.self
    )
    .compactMap { $0.data }
    .eraseToAnyPublisher()

    return result
  }

}
