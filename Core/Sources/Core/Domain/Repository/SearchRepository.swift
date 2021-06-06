//
//  SearchRepository.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine

public protocol SearchRepository {
  func getSearchGiphy(query: String) -> AnyPublisher<[Giphy], Error>
}
