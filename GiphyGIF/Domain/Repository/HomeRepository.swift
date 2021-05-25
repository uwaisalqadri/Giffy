//
//  HomeRepository.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine

protocol HomeRepository {
  func getTrendingGiphy() -> AnyPublisher<[Giphy], Error>
  func getRandomGiphy() -> AnyPublisher<[Giphy], Error>
}
