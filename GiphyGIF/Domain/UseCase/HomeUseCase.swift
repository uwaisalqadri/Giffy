//
//  HomeUseCase.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation
import Combine

public protocol HomeUseCase {
  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error>
}

open class HomeInteractor: HomeUseCase {

  private let repository: HomeRepository

  public init(repository: HomeRepository) {
    self.repository = repository
  }

  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error> {
    repository.getTrendingGiphy()
  }
}
