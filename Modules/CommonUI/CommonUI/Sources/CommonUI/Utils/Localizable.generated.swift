//
//  Localizable.generated.swift
//
//
//  Created by Uwais Alqadri on 19/9/23.
//

import Foundation

public enum Localizable: String {
  case titleProfile = "profile.title"
  case titleDetail = "detail.title"
  case titleFavorite = "favorite.title"
  case labelFavoriteEmpty = "favorite.empty_message"
  case labelTodayPopular = "trending.today_popular"
  case titleTrending = "trending.title"
  case labelTrendingDate = "trending.date"
  case titleSearch = "search.title"
  case labelSearchDesc = "search.placeholder"
  case labelSearching = "search.loading"
  case titleBackgroundRemoval = "common.background_removal"
  case labelCopied = "toast.copied"
  case labelShareVia = "share.option"
  case actionSelectPhotoLibrary = "modal.select_photo_library"
  case actionDelete = "button.delete"
  case errorCheckFavorite = "error.favorite_check"
  
  public func tr() -> String {
    localized
  }
  
  public var localized: String {
    Bundle.common.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}
