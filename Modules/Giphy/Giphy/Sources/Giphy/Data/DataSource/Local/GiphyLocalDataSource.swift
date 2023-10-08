//
//  GiphyLocalDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/19/21.
//

import Core
import Combine

public struct GiphyLocalDataSource: LocalDataSource {
  public typealias Request = String
  public typealias Response = Giphy

  public init() {}

  public func list(request: String?) async throws -> [Giphy] {
    var favoriteGiphys = try await CoreDataHelper.shared.getFavoriteGiphys().map { $0.map() }
    
    if let searchRequest = request, !searchRequest.isEmpty {
      favoriteGiphys = favoriteGiphys.filter { giphy in
        let contains = giphy.title.contains(searchRequest) ||
        giphy.username.contains(searchRequest) ||
        giphy.embedUrl.contains(searchRequest) ||
        giphy.type.contains(searchRequest) ||
        giphy.url.contains(searchRequest)
        
        return contains
      }
    }
    
    return favoriteGiphys
  }
  
  public func add(entity: Giphy) async throws -> Bool {
    return try await CoreDataHelper.shared.addFavoriteGiphy(item: entity)
  }
  
  public func delete(id: String) async throws -> Bool {
    return try await CoreDataHelper.shared.deleteFavoriteGiphy(with: id)
  }
  
  public func isFavorited(id: String) async throws -> Bool {
    return try await CoreDataHelper.shared.isGiphyFavorited(with: id)
  }
}
