//
//  Localizable.generated.swift
//
//
//  Created by Uwais Alqadri on 19/9/23.
//

import Foundation

public enum Localizable: String {
  // MARK: About
  case labelAboutMe = "about_me"
  case labelAboutMeDesc = "about_me_desc"
  case titleProfile = "profile"
  
  // MARK: Detail
  case titleDetail = "detail"
  
  // MARK: Favorite
  case titleFavorite = "favorite"
  case labelFavoriteEmpty = "favorite_empty"
  
  // MARK: Home
  case labelTodayPopular = "today_popular"
  case titleTrending = "trending"
  
  // MARK: Search
  case titleSearch = "search"
  case labelSearchDesc = "search_desc"
  case labelSearching = "searching_giphy"
  
  case labelTrendingDate = "trending_date"
  case titleBackgroundRemoval = "background_removal"
  case actionSelectPhotoLibrary = "select_photo_library"
  case actionDelete = "delete"
  case errorCheckFavorite = "error_check_favorite"
  case labelCopied = "copied"
  case labelShareVia = "share_via"
  
  public func tr() -> String {
    localized
  }
  
  public var localized: String {
    Bundle.common.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}
