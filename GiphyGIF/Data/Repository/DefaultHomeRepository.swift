//
//  HomeRepository.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine

public struct DefaultHomeRepository: HomeRepository {

  fileprivate let remoteDataSource: RemoteDataSource

  init(remoteDataSource: RemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error> {
    return remoteDataSource.getTrendingGiphy()
      .map { ObjectMapper.mapGiphyResponseToDomain(input: $0) }
      .eraseToAnyPublisher()
  }

  func getRandomGiphy() -> AnyPublisher<[Giphy], Error> {
    return remoteDataSource.getRandomGiphy()
      .map { ObjectMapper.mapGiphyResponseToDomain(input: $0) }
      .eraseToAnyPublisher()
  }
}
