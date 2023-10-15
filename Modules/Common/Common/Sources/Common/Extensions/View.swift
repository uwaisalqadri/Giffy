//
//  View.swift
//  
//
//  Created by Uwais Alqadri on 15/10/23.
//

import SwiftUI

public extension View {
  
  var window: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter({$0.activationState == .foregroundActive})
      .compactMap({$0 as? UIWindowScene})
      .first?.windows
      .filter({$0.isKeyWindow}).first
  }
}
