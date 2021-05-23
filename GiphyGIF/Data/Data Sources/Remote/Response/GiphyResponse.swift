//
//  Giphy.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

struct GiphyResponse: Decodable {
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
  let images: ImageItem

  enum CodingKeys: String, CodingKey {
    case type
    case id
    case url
    case embedUrl = "embed_url"
    case rating
    case username
    case title
    case trendingDateTime = "trending_date_time"
    case images
  }
}

struct ImageItem: Decodable {
  let original: OriginalItem

  enum CodingKeys: String, CodingKey {
    case original
  }
}

struct OriginalItem: Decodable {
  let url: String

  enum CodingKeys: String, CodingKey {
    case url
  }
}
