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

func getEndpoint(endpoint: EndPoints, apiKey: String, query: String) -> String {
  switch endpoint {
  case .search:
    return "search?api_key=\(apiKey)&q=\(query)"
  case .trending:
    return "trending?api_key=\(apiKey)"
  }
}
