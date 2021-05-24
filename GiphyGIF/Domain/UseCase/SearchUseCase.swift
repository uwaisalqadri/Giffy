//
//  SearchUseCase.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation
import Combine

protocol SearchUseCase {
  func getSearchGiphy(query: String) -> AnyPublisher<[Giphy], Error>
}

open class SearchInteractor: SearchUseCase {

  let repository: SearchRepository

  init(repository: SearchRepository) {
    self.repository = repository
  }

  func getSearchGiphy(query: String) -> AnyPublisher<[Giphy], Error> {
    repository.getSearchGiphy(query: query)
  }
}


