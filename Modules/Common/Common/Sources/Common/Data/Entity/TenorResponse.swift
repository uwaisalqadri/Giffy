//
//  TenorResponse.swift
//
//
//  Created by Uwais Alqadri on 12/10/24.
//

import Foundation

struct TenorDataResponse: Codable {
  let results: [TenorResponse]
  let next: String?
}

struct TenorResponse: Codable {
  let id, title, contentDescription, contentRating: String?
  let h1Title: String?
  let media: [[String: Media]]
  let bgColor: String?
  let created: Double?
  let itemurl: String?
  let url: String?
  let shares: Int?
  let hasaudio, hascaption: Bool?
  let sourceID: String?
  
  enum CodingKeys: String, CodingKey {
    case id, title
    case contentDescription = "content_description"
    case contentRating = "content_rating"
    case h1Title = "h1_title"
    case media
    case bgColor = "bg_color"
    case created, itemurl, url, shares, hasaudio, hascaption
    case sourceID = "source_id"
  }
}

struct Media: Codable {
  let preview: String?
  let duration: Double?
  let size: Int?
  let url: String?
  let dims: [Int]?
}
