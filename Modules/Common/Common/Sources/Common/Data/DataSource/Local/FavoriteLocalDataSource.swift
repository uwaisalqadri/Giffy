//
//  FavoriteLocalDataSource.swift
//  
//
//  Created by Uwais Alqadri on 10/19/21.
//

import Core
import Combine

public struct FavoriteLocalDataSource: LocalDataSource {
  public typealias Request = String
  public typealias Response = Giffy
  
  public init() {}
  
  public func list(request: String?) async throws -> [Giffy] {
    var favoriteGiphys = try await DBService.shared.getFavoriteGiphys().map { $0.map() }
    
    if let searchRequest = request, !searchRequest.isEmpty {
      let lowercaseSearchRequest = searchRequest.lowercased()
      
      favoriteGiphys = favoriteGiphys.filter { giphy in
        let title = giphy.title.lowercased()
        let username = giphy.username.lowercased()
        let url = giphy.url.lowercased()
        
        let contains = title.contains(lowercaseSearchRequest) ||
        username.contains(lowercaseSearchRequest) ||
        url.contains(lowercaseSearchRequest)
        
        return contains
      }
    }
    
    return favoriteGiphys.reversed()
  }
  
  public func add(entity: Giffy) async throws -> Bool {
    return try await DBService.shared.addFavoriteGiphy(item: entity)
  }
  
  public func delete(id: String) async throws -> Bool {
    return try await DBService.shared.deleteFavoriteGiphy(with: id)
  }
  
  public func isFavorited(id: String) async throws -> Bool {
    return try await DBService.shared.isGiphyFavorited(with: id)
  }
}
