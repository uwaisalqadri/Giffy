//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 19/9/23.
//

import Foundation

public enum AboutString: String {
  case labelAboutMe = "about_me"
  case labelAboutMeDesc = "about_me_desc"
  case titleProfile = "profile"
  
  public var localized: String {
    Bundle.module.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}

public enum DetailString: String {
  case titleDetail = "detail"
  
  public var localized: String {
    Bundle.module.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}

public enum FavoriteString: String {
  case titleFavorite = "favorite"
  case labelFavoriteEmpty = "favorite_empty"
  
  public var localized: String {
    Bundle.module.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}

public enum HomeString: String {
  case labelTodayPopular = "today_popular"
  case titleTrending = "trending"
  
  public var localized: String {
    Bundle.module.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}

public enum SearchString: String {
  case titleSearch = "search"
  case labelSearchDesc = "search_desc"
  case labelSearching = "searching_giphy"
  
  public var localized: String {
    Bundle.module.localizedString(forKey: self.rawValue, value: nil, table: nil)
  }
}
