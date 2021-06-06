//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 01/06/21.
//

import Combine

public protocol DetailRepository {
  func addToFavoriteGiphys(from giphy: Giphy) -> AnyPublisher<Bool, Error>
  func getFavoriteGiphys() -> AnyPublisher<[Giphy], Error>
  func removeFavoriteGiphy(from idGiphy: String) -> AnyPublisher<Bool, Error>
}
