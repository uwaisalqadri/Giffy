//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 20/9/23.
//

import Foundation
import CoreData

extension GiphyEntity {
  public func map() -> Giphy {
    return Giphy(
      type: self.type ?? "",
      id: self.id ?? "",
      url: url ?? "",
      embedUrl: embedUrl ?? "",
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
  public func map() -> Giphy {
    return Giphy(
      type: self.type ?? "",
      id: self.id ?? "",
      url: url ?? "",
      embedUrl: embedUrl ?? "",
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
