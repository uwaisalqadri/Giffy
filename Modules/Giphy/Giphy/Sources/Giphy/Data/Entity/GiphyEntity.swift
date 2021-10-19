//
//  GiphyEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import ObjectMapper
import RealmSwift

public struct GiphyResponse: Mappable {
  public var data: [GiphyEntity]?

  public init?(map: Map) {
    mapping(map: map)
  }

  mutating public func mapping(map: Map) {
    data <- map["data"]
  }
}

public struct GiphyEntity: Giphy, Mappable {
  public var type: String = ""
  public var identifier: String = ""
  public var url: String = ""
  public var embedUrl: String = ""
  public var rating: String = ""
  public var username: String = ""
  public var title: String = ""
  public var trendingDateTime: String = ""
  public var isFavorite: Bool = false

  public var _images: ImageGIFEntity?
  public var images: ImageGIF? {
    _images
  }

  public init?(map: Map) {
    mapping(map: map)
  }

  mutating public func mapping(map: Map) {
    type <- map["type"]
    identifier <- map["id"]
    url <- map["url"]
    embedUrl <- map["embed_url"]
    rating <- map["rating"]
    username <- map["username"]
    title <- map["title"]
    trendingDateTime <- map["trending_datetime"]
    _images <- map["images"]
  }
}
