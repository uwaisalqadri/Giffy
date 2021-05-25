//
//  ObjectMapper.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import Foundation

final class ObjectMapper {

  static func mapGiphyResponseToDomain(
    input giphyResponse: [GiphyItem]
  ) -> [Giphy] {

    return giphyResponse.map { result in
      return Giphy(
        type: result.type,
        id: result.id,
        url: result.url,
        embedUrl: result.embedUrl,
        rating: result.rating,
        username: result.username,
        title: result.title,
        trendingDateTime: result.trendingDateTime,
        images: mapImageResponseToDomain(input: result.images)
      )
    }
  }

  static func mapImageResponseToDomain(
    input imageResponse: ImageItem
  ) -> ImageGIF {
    return ImageGIF(original: mapOriginalResponseToDomain(input: imageResponse.original))
  }

  static func mapOriginalResponseToDomain(
    input originalResponse: OriginalItem
  ) -> Original {
    return Original(
      url: originalResponse.url,
      height: originalResponse.height,
      width: originalResponse.width
    )
  }
}
