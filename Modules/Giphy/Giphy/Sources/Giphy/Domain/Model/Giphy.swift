//
//  Giphy.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

public protocol Giphy {
  var type: String { get }
  var identifier: String { get }
  var url: String { get }
  var embedUrl: String { get }
  var rating: String { get }
  var username: String { get }
  var title: String { get }
  var trendingDateTime: String { get }
  var images: ImageGIF? { get }
}
