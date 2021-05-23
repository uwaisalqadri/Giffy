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
}

func getEndpoint(endpoint: EndPoints, apiKey: String, query: String = "ios") -> String {
  switch endpoint {
  case .search:
    return "search?api_key=\(apiKey)&q=\(query)"
  case .trending:
    return "trending?api_key=\(apiKey)"
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

enum DatabaseError: LocalizedError {

  case invalidInstance
  case requestFailed

  var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Database can't instance."
    case .requestFailed: return "Your request failed."
    }
  }

}
