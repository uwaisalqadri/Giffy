//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 20/9/23.
//

import Foundation
import CoreData

extension GiphyEntity {
  public func map() -> Giffy {
    return Giffy(
      id: self.id ?? "",
      url: url ?? "",
      rating: rating ?? "",
      username: username ?? "",
      title: title ?? "",
      trendingDateTime: trendingDateTime ?? "",
      image: .init(
        url: image?.url ?? "",
        height: image?.height ?? "",
        width: image?.width ?? ""
      ),
      isFavorite: false
    )
  }
}

extension GiphyResponse {
  public func map() -> Giffy {
    return Giffy(
      id: self.id ?? "",
      url: url ?? "",
      rating: rating ?? "",
      username: username ?? "",
      title: title ?? "",
      trendingDateTime: trendingDateTime ?? "",
      image: .init(
        url: images?.original?.url ?? "",
        height: images?.original?.height ?? "",
        width: images?.original?.width ?? ""
      ),
      isFavorite: false
    )
  }
}

extension TenorResponse {
  public func map() -> Giffy {
    let gifMedia = media.first(where: { $0["gif"] != nil })?["gif"]
    return Giffy(
      id: self.id ?? "",
      url: url ?? "",
      rating: contentRating ?? "",
      username: title ?? "",
      title: h1Title ?? "",
      trendingDateTime: "",
      image: .init(
        url: gifMedia?.url ?? "",
        height: String(gifMedia?.dims?.last ?? 0),
        width: String(gifMedia?.dims?.first ?? 0)
      ),
      isFavorite: false
    )
  }
}
