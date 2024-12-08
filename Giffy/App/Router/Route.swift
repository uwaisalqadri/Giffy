//
//  AppRoute.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import Common

public enum AppRoute: RouterIdentifiable {
  case main
  case home
  case search
  case favorite
  case detail(items: [Giffy])

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
  public static var defaultRouter: Router<AppRoute> = Router()

  public var wrappedValue: Router<AppRoute> {
    get { customValue ?? Self.defaultRouter }
    set { customValue = newValue }
  }
}
