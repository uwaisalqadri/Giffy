//
//  API.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

enum EndPoints {
  case search
  case trending
  case random
}

func getEndpoint(endpoint: EndPoints, query: String = "ios") -> String {
  switch endpoint {
  case .search:
    return "search?api_key=\(Constants.apiKey)&q=\(query)"
  case .trending:
    return "trending?api_key=\(Constants.apiKey)"
  case .random:
  return "random?api_key=\(Constants.apiKey)"
  }
}

enum URLError: LocalizedError {

  case invalidResponse
  case addressUnreachable(URL)

  var errorDescription: String? {
    switch self {
    case .invalidResponse: return "The server responded with garbage."
    case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
    }
  }

}
