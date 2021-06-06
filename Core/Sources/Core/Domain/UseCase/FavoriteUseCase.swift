//
//  FavoriteUseCase.swift
//  
//
//  Created by Uwais Alqadri on 06/06/21.
//

import Foundation
import Combine

public protocol FavoriteUseCase {
  func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error>
  func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error>
}

open class FavoriteInteractor: FavoriteUseCase {

  private let repository: FavoriteRepository

  public init(repository: FavoriteRepository) {
    self.repository = repository
  }

  public func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error> {
    repository.getFavoriteGiphys()
  }

  public func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error> {
    repository.removeFavoriteGiphy(from: idGiphy)
  }
}
