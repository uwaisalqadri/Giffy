//
//  ApiFactory.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

public enum APIFactory {
  case trending
  case random
  case search(query: String)
}

public extension APIFactory {
  var url: URL {
    let params = parameter.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    let urlString = baseURL.appending(path)
      .appending("?")
      .appending(params)
    return URL(string: urlString) ?? URL.init(fileURLWithPath: "")
  }

  private var baseURL: String {
    Config.baseUrl
  }

  private var path: String {
    switch self {
    case .random:
      return "random"
    case .trending:
      return "trending"
    case .search:
      return "search"
    }
  }

  private var parameter: [String: Any] {
    var defaultParams = ["api_key": Config.apiKey]
    switch self {
    case .search(let query) where query.count > 0:
      defaultParams["q"] = query
    default:
      break
    }
    return defaultParams
  }
}

