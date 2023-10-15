//
//  GiphyGIFApp.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import ComposableArchitecture
import Common

@main
struct GiphyApp: App {
  
  init() {
    Font.loadCustomFont()
  }
  
  var body: some Scene {
    WindowGroup {
      MainTabView(store: Injection.shared.resolve())
    }
  }
}
