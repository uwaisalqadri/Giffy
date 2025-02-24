//
//  Giphy.swift
//
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

public struct Giffy: Equatable, Hashable {
  public static func == (lhs: Giffy, rhs: Giffy) -> Bool {
    lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(id)
  }
  
  public var id: String
  public var url: String
  public var rating: String
  public var username: String
  public var title: String
  public var trendingDateTime: String
  public var image: ImageOriginal
  public var isFavorite: Bool
  public var isHighlighted: Bool
  
  public init(
    id: String = "",
    url: String = "",
    rating: String = "",
    username: String = "",
    title: String = "",
    trendingDateTime: String = "",
    image: ImageOriginal = .init(),
    isFavorite: Bool = false,
    isHighlighted: Bool = false
  ) {
    self.id = id
    self.url = url
    self.rating = rating
    self.username = username
    self.title = title
    self.trendingDateTime = trendingDateTime
    self.image = image
    self.isFavorite = isFavorite
    self.isHighlighted = isHighlighted
  }
  
  public func setFavorite(_ state: Bool) -> Giffy {
    return Giffy(
      id: id,
      url: url,
      rating: rating,
      username: username,
      title: title,
      trendingDateTime: trendingDateTime,
      image: image,
      isFavorite: state
    )
  }
}

public struct ImageOriginal {
  public var url: String
  public var data: Data?
  public var height: String
  public var width: String
  
  public init(
    url: String = "",
    data: Data? = nil,
    height: String = "",
    width: String = ""
  ) {
    self.url = url
    self.data = data
    self.height = height
    self.width = width
  }
}
