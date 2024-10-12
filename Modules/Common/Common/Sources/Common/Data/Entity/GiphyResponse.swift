//
//  GiphyEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

class GiphyDataResponse: Codable {
  var data = [GiphyResponse]()

  enum CodingKeys: String, CodingKey {
    case data
  }
}

class GiphyResponse: Codable {
  var type: String?
  var id: String?
  var url: String?
  var embedUrl: String?
  var rating: String?
  var username: String?
  var title: String?
  var trendingDateTime: String?
  var images: ImageGIFResponse?
  
  enum CodingKeys: String, CodingKey {
    case type
    case id
    case url
    case embedUrl = "embed_url"
    case rating
    case username
    case title
    case trendingDateTime = "trending_datetime"
    case images
  }
}
