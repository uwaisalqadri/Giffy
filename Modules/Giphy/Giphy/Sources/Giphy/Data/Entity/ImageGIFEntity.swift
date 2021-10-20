//
//  ImageGIFEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import RealmSwift
import ObjectMapper
import ObjectMapperAdditions

public class ImageGIFEntity: Object, ImageGIF, Mappable, RealmOptionalType {
  dynamic public var _original: OriginalEntity?
  dynamic public var original: Original? {
    _original
  }

  required public init?(map: ObjectMapper.Map) {
    super.init()
    mapping(map: map)
  }

  public func mapping(map: ObjectMapper.Map) {
    _original <- map["original"]
  }
}

public class OriginalEntity: Object, Original, Mappable, RealmOptionalType {
  dynamic public var url: String = ""
  dynamic public var height: String = ""
  dynamic public var width: String = ""

  required public init?(map: ObjectMapper.Map) {
    super.init()
    mapping(map: map)
  }

  public func mapping(map: ObjectMapper.Map) {
    url <- (map["url"], StringTransform())
    height <- (map["height"], StringTransform())
    width <- (map["width"], StringTransform())
  }
}
