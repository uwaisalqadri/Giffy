//
//  GiphyLocalDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/19/21.
//

import Core
import Combine

public struct GiphyLocalDataSource: LocalDataSource {
  public typealias Request = String
  public typealias Response = Giphy

  public init() {}

  public func list(request: String?) -> AnyPublisher<[Giphy], Error> {
    return CoreDataHelper.shared.getFavoriteGiphys()
      .compactMap { $0.map { $0.map() } }
      .eraseToAnyPublisher()
  }
  
  public func add(entity: Giphy) -> AnyPublisher<Bool, Error> {
    return CoreDataHelper.shared.addFavoriteGiphy(item: entity)
      .eraseToAnyPublisher()
  }
  
  public func delete(id: String) -> AnyPublisher<Bool, Error> {
    return CoreDataHelper.shared.deleteFavoriteGiphy(with: id)
      .eraseToAnyPublisher()
  }
  
  public func isFavorited(id: String) -> AnyPublisher<Bool, Error> {
    return CoreDataHelper.shared.isGiphyFavorited(with: id)
      .eraseToAnyPublisher()
  }
}
