//
//  GiphyEntity.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import RealmSwift

public class GiphyResponse: Object, Codable {
  dynamic public var _data = List<GiphyEntity>()
  public var data: [Giphy] {
    _data.map()
  }

  public enum CodingKeys: String, CodingKey {
    case _data = "data"
  }
}

public class GiphyEntity: Object, Giphy, Codable {
  @objc dynamic public var type: String = ""
  @objc dynamic public var identifier: String = ""
  @objc dynamic public var url: String = ""
  @objc dynamic public var embedUrl: String = ""
  @objc dynamic public var rating: String = ""
  @objc dynamic public var username: String = ""
  @objc dynamic public var title: String = ""
  @objc dynamic public var trendingDateTime: String = ""
  public var isFavorite: Bool = false

  @objc dynamic public var _images: ImageGIFEntity?
  public var images: ImageGIF {
    _images ?? .init()
  }

  public override class func primaryKey() -> String? {
    "identifier"
  }

  public enum CodingKeys: String, CodingKey {
    case type = "type"
    case identifier = "id"
    case url = "url"
    case embedUrl = "embed_url"
    case rating = "rating"
    case username = "username"
    case title = "title"
    case trendingDateTime = "trending_datetime"
    case _images = "images"
  }
}

extension List where Element == GiphyEntity {
  func map() -> [Giphy] {
    var results = [Giphy]()
    for value in self {
      results.append(value)
    }
    return results
  }
}
