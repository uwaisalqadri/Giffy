//
//  HomeUseCase.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation
import Combine

protocol HomeUseCase {
  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error>
  func getRandomGiphy() -> AnyPublisher<[Giphy], Error>
}

open class HomeInteractor: HomeUseCase {

  private let repository: HomeRepository

  init(repository: HomeRepository) {
    self.repository = repository
  }

  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error> {
    repository.getTrendingGiphy()
  }

  func getRandomGiphy() -> AnyPublisher<[Giphy], Error> {
    repository.getRandomGiphy()
  }
}
