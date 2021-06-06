//
//  DefaultFavoriteRepository.swift
//  
//
//  Created by Uwais Alqadri on 06/06/21.
//

import Combine

public struct DefaultFavoriteRepository: FavoriteRepository {

  fileprivate let localDataSource: LocalDataSource

  public init(localDataSource: LocalDataSource) {
    self.localDataSource = localDataSource
  }

  public func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error> {
    return localDataSource.getFavoriteGiphys()
      .map { ObjectMapper.mapFavGiphyObjectsToDomains(input: $0) }
      .eraseToAnyPublisher()
  }

  public func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error> {
    return localDataSource.removeFavoriteGiphy(from: idGiphy)
  }
}
