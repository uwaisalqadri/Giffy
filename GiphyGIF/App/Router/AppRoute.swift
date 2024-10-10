//
//  AppRoute.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import Giphy

public enum AppRoute: RouterIdentifiable {
  case main
  case home
  case search
  case favorite
  case detail(_ item: Giphy)

  public var key: String {
    switch self {
    case .main:
      return "main"
    case .home:
      return "main"
    case .search:
      return "search"
    case .favorite:
      return "favorite"
    case .detail:
      return "detail"
    }
  }
}

@propertyWrapper
public struct Route {
  public init() {}

  private var customValue: Router<AppRoute>?
  public var wrappedValue: Router<AppRoute> {
    get { customValue ?? RouteWrapperValues.router }
    set { customValue = newValue }
  }
}

public struct RouteWrapperValues {
  private static var current = RouteWrapperValues()
  public static var router: Router<AppRoute> {
    get { RouterWrapperKey.currentValue }
    set { RouterWrapperKey.currentValue = newValue }
  }
}

struct RouterWrapperKey {
  static var currentValue: Router<AppRoute> = Router()
}
