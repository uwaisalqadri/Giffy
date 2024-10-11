//
//  TenorAPI.swift
//  
//
//  Created by Uwais Alqadri on 11/10/24.
//

import Foundation

public enum TenorAPI {
  case search(query: String)
}

extension TenorAPI: APIFactory {
  public var path: String {
    switch self {
    case .search:
      return "search"
    }
  }
  
  public var parameter: [String: Any] {
    switch self {
    case let .search(query):
      return ["q": query, "key": "LIVDSRZULELA", "limit": 100]
    }
  }
  
  public var composedURL: URL {
    let params = parameter.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    let urlString = baseURL.appending(path)
      .appending("?")
      .appending(params)
    return URL(string: urlString) ?? URL.init(fileURLWithPath: "")
  }
  
  public var baseURL: String {
    APIConfig.tenorBaseUrl
  }
}
