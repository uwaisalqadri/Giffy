//
//  ImageGIFEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import ObjectMapper

public struct ImageGIFEntity: ImageGIF, Mappable {
  public var _original: OriginalEntity?
  public var original: Original? {
    _original
  }

  public init?(map: Map) {
    mapping(map: map)
  }

  mutating public func mapping(map: Map) {
    _original <- map["original"]
  }
}

public struct OriginalEntity: Original, Mappable {
  public var url: String = ""
  public var height: String = ""
  public var width: String = ""

  public init?(map: Map) {
    mapping(map: map)
  }

  mutating public func mapping(map: Map) {
    url <- map["url"]
    height <- map["height"]
    width <- map["width"]
  }
}
