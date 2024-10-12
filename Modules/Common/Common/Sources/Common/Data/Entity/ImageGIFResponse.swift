//
//  ImageGIFEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

struct ImageGIFResponse: Codable {
  var original: ImageOriginalResponse?
  
  init() {}
  
  enum CodingKeys: String, CodingKey {
    case original
  }
}

struct ImageOriginalResponse: Codable {
  var url: String?
  var height: String?
  var width: String?

  enum CodingKeys: String, CodingKey {
    case url, height, width
  }
}
