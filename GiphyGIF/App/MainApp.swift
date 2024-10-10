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
struct MainApp: App {
  @Route var router

  init() {
    Font.loadCustomFont()
  }
  
  var body: some Scene {
    WindowGroup {
      RouteView(
        store: Store(initialState: RouteReducer.State()) {
          RouteReducer()
        }
      )
      .onAppear {
        router.makeRoot(.main)
      }
    }
  }
}
