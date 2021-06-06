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

  static func mapGiphyResponseToObject(
    input giphyResponse: [GiphyItem]
  ) -> [GiphyObject] {

    return giphyResponse.map { result in
      let giphy = GiphyObject()
      giphy.type = result.type
      giphy.id = result.id
      giphy.url = result.url
      giphy.embedUrl = result.embedUrl
      giphy.rating = result.rating
      giphy.username = result.username
      giphy.title = result.title
      giphy.trendingDateTime = result.trendingDateTime
      giphy.imageUrl = result.images.original.url
      giphy.height = result.images.original.height
      giphy.width = result.images.original.width
      return giphy
    }
  }

  static func mapGiphyObjectToDomain(
    input giphyObject: [GiphyObject]
  ) -> [Giphy] {

    return giphyObject.map { result in
      return Giphy(
        type: result.type,
        id: result.id,
        url: result.url,
        embedUrl: result.embedUrl,
        rating: result.rating,
        username: result.username,
        title: result.title,
        trendingDateTime: result.trendingDateTime,
        images: ImageGIF(original: Original(url: result.imageUrl, height: result.height, width: result.width))
      )
    }
  }

  static func mapFavGiphyObjectsToDomains(
    input giphyObject: [FavGiphyObject]
  ) -> [Giphy] {

    return giphyObject.map { result in
      return Giphy(
        type: result.type,
        id: result.id,
        url: result.url,
        embedUrl: result.embedUrl,
        rating: result.rating,
        username: result.username,
        title: result.title,
        trendingDateTime: result.trendingDateTime,
        images: ImageGIF(original: Original(url: result.imageUrl, height: result.height, width: result.width))
      )
    }
  }

  static func mapDomainToFavGiphyObject(
    input giphy: Giphy
  ) -> FavGiphyObject {
    let object = FavGiphyObject()
    object.type = giphy.type
    object.id = giphy.id
    object.url = giphy.url
    object.embedUrl = giphy.embedUrl
    object.rating = giphy.rating
    object.username = giphy.username
    object.title = giphy.title
    object.trendingDateTime = giphy.trendingDateTime
    object.imageUrl = giphy.images.original.url
    object.height = giphy.images.original.height
    object.width = giphy.images.original.width
    return object
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
