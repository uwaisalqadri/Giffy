//
//  DefaultDetailRepository.swift
//  
//
//  Created by Uwais Alqadri on 01/06/21.
//

import Combine

public struct DefaultDetailRepository: DetailRepository {

  fileprivate let localDataSource: LocalDataSource

  public init(localDataSource: LocalDataSource) {
    self.localDataSource = localDataSource
  }

  public func addToFavoriteGiphys(from giphy: Giphy) -> AnyPublisher<Bool, Error> {
    let object = ObjectMapper.mapDomainToFavGiphyObject(input: giphy)
    return localDataSource.addToFavoriteGiphys(from: object)
      .eraseToAnyPublisher()
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
