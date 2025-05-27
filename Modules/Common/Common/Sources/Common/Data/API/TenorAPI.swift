//
//  TenorAPI.swift
//  
//
//  Created by Uwais Alqadri on 11/10/24.
//

import Foundation

public enum TenorAPI {
  case search(query: String, limit: Int = 100)
}

extension TenorAPI: APIFactory {
  public var path: String {
    switch self {
    case .search:
      return "search"
    }
  }
  
  public var parameters: [String: Any] {
    var defaultParams: [String: Any] = ["key": APIConfig.tenorConfig.apiKey]
    switch self {
    case let .search(query, limit) where query.count > 0:
      defaultParams["q"] = query
      defaultParams["limit"] = limit
    default:
      break
    }
    return defaultParams
  }
  
  public var baseURL: String {
    APIConfig.tenorConfig.baseUrl
  }
  
  public var method: HTTPMethod {
     return .get // assuming all are GET requests
   }

   public var headers: [String: String] {
     [:] // or provide default headers if needed
   }

   public var bodyData: Data? {
     nil // not used in GET requests
   }
}
