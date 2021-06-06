//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 01/06/21.
//

import Foundation
import Combine

public protocol DetailUseCase {
  func addToFavoriteGiphys(from giphy: Giphy) -> AnyPublisher<Bool, Error>
  func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error>
  func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error>
}

open class DetailInteractor: DetailUseCase {

  private let repository: DetailRepository

  public init(repository: DetailRepository) {
    self.repository = repository
  }

  public func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error> {
    repository.getFavoriteGiphys()
  }

  public func addToFavoriteGiphys(from giphy: Giphy) -> AnyPublisher<Bool, Error> {
    repository.addToFavoriteGiphys(from: giphy)
  }

  public func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error> {
    repository.removeFavoriteGiphy(from: idGiphy)
  }
}
