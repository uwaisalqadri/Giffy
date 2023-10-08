//
//  GiphyGIFApp.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct GiphyGIFApp: App {
  var body: some Scene {
    WindowGroup {
      MainTabView(store: Injection.shared.resolve())
    }
  }
}
