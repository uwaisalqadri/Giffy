//
//  FavoriteRepository.swift
//  
//
//  Created by Uwais Alqadri on 06/06/21.
//

import Combine

public protocol FavoriteRepository {
  func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error>
  func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error>
}
