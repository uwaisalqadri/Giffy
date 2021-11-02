//
//  ImageGIFEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapperAdditions

public class ImageGIFEntity: Object, ImageGIF, Mappable, RealmOptionalType {
  @objc dynamic public var _original: OriginalEntity?
  public var original: Original? {
    _original
  }

  public override init() {
    super.init()
  }

  public required init?(map: ObjectMapper.Map) {
    super.init()
    mapping(map: map)
  }

  public func mapping(map: ObjectMapper.Map) {
    _original <- map["original"]
  }
}

public class OriginalEntity: Object, Original, Mappable {
  @objc dynamic public var url: String = ""
  @objc dynamic public var height: String = ""
  @objc dynamic public var width: String = ""

  public override init() {
    super.init()
  }

  public required init?(map: ObjectMapper.Map) {
    super.init()
    mapping(map: map)
  }

  public func mapping(map: ObjectMapper.Map) {
    url <- (map["url"], StringTransform())
    height <- (map["height"], StringTransform())
    width <- (map["width"], StringTransform())
  }
}
