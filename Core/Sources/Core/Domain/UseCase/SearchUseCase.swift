//
//  SearchUseCase.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation
import Combine

public protocol SearchUseCase {
  func getSearchGiphy(query: String) -> AnyPublisher<[Giphy], Error>
}

open class SearchInteractor: SearchUseCase {

  private let repository: SearchRepository

  public init(repository: SearchRepository) {
    self.repository = repository
  }

  public func getSearchGiphy(query: String) -> AnyPublisher<[Giphy], Error> {
    repository.getSearchGiphy(query: query)
  }

}
