//
//  Notifications.swift
//
//
//  Created by Uwais Alqadri on 08/12/24.
//

import Foundation

public struct Notifications {
  public static let onDetailDisappear = Notification.Name(rawValue: "onDetailDisappear")
  public static let didGIFCopied = Notification.Name(rawValue: "didGIFCopied")
}

public extension Notification.Name {
  func post(with object: Any? = nil, userInfo: [String: Any]? = nil) {
    NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
  }
}
