//
//  Giphy.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

struct GiphyResponse {
  let data: [GiphyItem]

  enum CodingKeys: String, CodingKey {
    case data
  }
}

struct GiphyItem: Identifiable, Decodable {
  let type: String
  let id: String
  let url: String
  let embedUrl: String
  let rating: String
  let username: String
  let title: String
  let trendingDateTime: String
  let images: Image

  enum CodingKeys: String, CodingKey {
    case type
    case id
    case url
    case embedUrl
    case rating
    case username
    case title
    case trendingDateTime
    case images
  }
}

struct Image: Decodable {
  let original: Original

  enum CodingKeys: String, CodingKey {
    case original
  }
}

struct Original: Decodable {
  let url: String

  enum CodingKeys: String, CodingKey {
    case url
  }
}
