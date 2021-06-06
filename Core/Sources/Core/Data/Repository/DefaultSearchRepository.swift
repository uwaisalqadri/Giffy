//
//  DefaultSearchRepository.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine

public struct DefaultSearchRepository: SearchRepository {

  fileprivate let remoteDataSource: RemoteDataSource

  public init(remoteDataSource: RemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  public func getSearchGiphy(query: String) -> AnyPublisher<[Giphy], Error> {
    return remoteDataSource.getSearchGiphy(query: query)
      .map { ObjectMapper.mapGiphyResponseToDomain(input: $0) }
      .eraseToAnyPublisher()
  }
}
