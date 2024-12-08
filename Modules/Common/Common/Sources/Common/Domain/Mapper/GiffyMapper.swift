//
//  File.swift
//
//
//  Created by Uwais Alqadri on 20/9/23.
//

import Foundation
import CoreData

extension Giffy {
  init(from entity: GiphyEntity) {
    self.init(
      id: entity.id ?? "",
      url: entity.url ?? "",
      rating: entity.rating ?? "",
      username: entity.username ?? "",
      title: entity.title ?? "",
      trendingDateTime: entity.trendingDateTime ?? "",
      image: .init(
        url: entity.image?.url ?? "",
        height: entity.image?.height ?? "",
        width: entity.image?.width ?? ""
      ),
      isFavorite: false
    )
  }
}

extension Giffy {
  init(from response: GiphyResponse) {
    self.init(
      id: response.id ?? "",
      url: response.url ?? "",
      rating: response.rating ?? "",
      username: response.username ?? "",
      title: response.title ?? "",
      trendingDateTime: response.trendingDateTime ?? "",
      image: .init(
        url: response.images?.original?.url ?? "",
        height: response.images?.original?.height ?? "",
        width: response.images?.original?.width ?? ""
      ),
      isFavorite: false
    )
  }
}

extension Giffy {
  init(from response: TenorResponse) {
    let gifMedia = response.media.first(where: { $0["gif"] != nil })?["gif"]
    self.init(
      id: response.id ?? "",
      url: response.url ?? "",
      rating: response.contentRating ?? "",
      username: response.title ?? "",
      title: response.h1Title ?? "",
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

public extension [Giffy] {
  func setHighlighted(_ item: Giffy) -> Self {
    var newSelf = self
    let position = newSelf.firstIndex(where: { $0.id == item.id }) ?? 0
    newSelf[position].isHighlighted = true
    return newSelf
  }
}
