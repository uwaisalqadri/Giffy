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
  fileprivate let localDataSource: LocalDataSource

  init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
    self.remoteDataSource = remoteDataSource
    self.localDataSource = localDataSource
  }

  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error> {
    return localDataSource.getSavedGiphy()
      .flatMap { result -> AnyPublisher<[Giphy], Error> in
        if result.isEmpty {
          return remoteDataSource.getTrendingGiphy()
            .map { ObjectMapper.mapGiphyResponseToObject(input: $0) }
            .catch { _ in localDataSource.getSavedGiphy() }
            .flatMap { localDataSource.addToSavedGiphy(from: $0) }
            .filter { $0 }
            .flatMap { _ in localDataSource.getSavedGiphy()
              .map { ObjectMapper.mapGiphyObjectToDomain(input: $0) }
            }
            .eraseToAnyPublisher()
        } else {
          return localDataSource.getSavedGiphy()
            .map { ObjectMapper.mapGiphyObjectToDomain(input: $0) }
            .eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }

  func getRandomGiphy() -> AnyPublisher<[Giphy], Error> {
    return remoteDataSource.getRandomGiphy()
      .map { ObjectMapper.mapGiphyResponseToDomain(input: $0) }
      .eraseToAnyPublisher()
  }
}
