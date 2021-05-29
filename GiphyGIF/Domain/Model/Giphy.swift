//
//  Giphy.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation

struct Giphy: Identifiable, Decodable {
  let type: String
  let id: String
  let url: String
  let embedUrl: String
  let rating: String
  let username: String
  let title: String
  let trendingDateTime: String
  let images: ImageGIF
  let favorite: Bool
}

struct ImageGIF: Decodable {
  let original: Original

}

struct Original: Decodable {
  let url: String
  let height: String
  let width: String
}
