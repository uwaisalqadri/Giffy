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
      let lowercaseSearchRequest = searchRequest.lowercased()
      
      favoriteGiphys = favoriteGiphys.filter { giphy in
        // Convert all properties to lowercase for case-insensitive search
        let title = giphy.title.lowercased()
        let username = giphy.username.lowercased()
        let embedUrl = giphy.embedUrl.lowercased()
        let type = giphy.type.lowercased()
        let url = giphy.url.lowercased()
        
        // Check if any property contains the search request
        let contains = title.contains(lowercaseSearchRequest) ||
        username.contains(lowercaseSearchRequest) ||
        embedUrl.contains(lowercaseSearchRequest) ||
        type.contains(lowercaseSearchRequest) ||
        url.contains(lowercaseSearchRequest)
        
        return contains
      }
    }
    
    return favoriteGiphys.reversed()
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
