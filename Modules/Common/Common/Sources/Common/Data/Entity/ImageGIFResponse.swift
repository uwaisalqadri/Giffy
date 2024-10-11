//
//  ImageGIFEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

public struct ImageGIFResponse: Codable {
  public var original: ImageOriginalResponse?
  
  public init() {}
  
  public enum CodingKeys: String, CodingKey {
    case original
  }
}

public struct ImageOriginalResponse: Codable {
  public var url: String?
  public var height: String?
  public var width: String?

  public enum CodingKeys: String, CodingKey {
    case url, height, width
  }
}
