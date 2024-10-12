//
//  GiphyAPI.swift
//
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

public enum GiphyAPI {
  case trending
  case random
  case search(query: String)
}

extension GiphyAPI: APIFactory {
  public var baseURL: String {
    APIConfig.giphyBaseUrl
  }

  public var path: String {
    switch self {
    case .random:
      return "random"
    case .trending:
      return "trending"
    case .search:
      return "search"
    }
  }

  public var parameter: [String: Any] {
    var defaultParams: [String: Any] = ["api_key": APIConfig.giphyApiKey]
    switch self {
    case .search(let query) where query.count > 0:
      defaultParams["q"] = query
    default:
      break
    }
    return defaultParams
  }

  public var composedURL: URL {
    let params = parameter.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    let urlString = baseURL.appending(path)
      .appending("?")
      .appending(params)
    return URL(string: urlString) ?? URL.init(fileURLWithPath: "")
  }
}
