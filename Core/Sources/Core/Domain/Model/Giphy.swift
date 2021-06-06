//
//  Giphy.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

public struct Giphy: Identifiable, Decodable {
  public let type: String
  public let id: String
  public let url: String
  public let embedUrl: String
  public let rating: String
  public let username: String
  public let title: String
  public let trendingDateTime: String
  public let images: ImageGIF

  public init(type: String, id: String, url: String, embedUrl: String, rating: String, username: String, title: String, trendingDateTime: String, images: ImageGIF) {
    self.type = type
    self.id = id
    self.url = url
    self.embedUrl = embedUrl
    self.rating = rating
    self.username = username
    self.title = title
    self.trendingDateTime = trendingDateTime
    self.images = images
  }
}

public struct ImageGIF: Decodable {
  public let original: Original

  public init(original: Original) {
    self.original = original
  }
}

public struct Original: Decodable {
  public let url: String
  public let height: String
  public let width: String

  public init(url: String, height: String, width: String) {
    self.url = url
    self.height = height
    self.width = width
  }
}
