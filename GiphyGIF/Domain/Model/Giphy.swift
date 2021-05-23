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
  let images: Image
}

struct Image: Decodable {
  let original: Original

}

struct Original: Decodable {
  let url: String
}
