//
//  Giphy.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

public struct GiphyResponse: Decodable {
  let data: [GiphyItem]

  enum CodingKeys: String, CodingKey {
    case data
  }
}

public struct GiphyItem: Identifiable, Decodable {
  let type: String
  public let id: String
  let url: String
  let embedUrl: String
  let rating: String
  let username: String
  let title: String
  let slug: String
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
    case slug
    case trendingDateTime = "trending_datetime"
    case images
  }
}

public struct ImageItem: Decodable {
  let original: OriginalItem

  enum CodingKeys: String, CodingKey {
    case original
  }
}

public struct OriginalItem: Decodable {
  let url: String
  let height: String
  let width: String

  enum CodingKeys: String, CodingKey {
    case url
    case height
    case width
  }
}
