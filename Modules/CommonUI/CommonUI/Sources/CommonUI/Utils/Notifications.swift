//
//  Notifications.swift
//
//
//  Created by Uwais Alqadri on 08/12/24.
//

import Foundation

public struct Notifications {
  public static let onDetailDisappear = Notification.Name(rawValue: "onDetailDisappear")
}

public extension Notification.Name {
  func post(with object: Any? = nil) {
    NotificationCenter.default.post(name: self, object: object)
  }
}
