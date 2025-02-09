//
//  GiphyGIFApp.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import ComposableArchitecture
import Common
import netfox

@main
struct MainApp: App {
  @Router var router

  init() {
    Font.loadAllFonts()
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
        NFX.sharedInstance().start()
      }
    }
  }
}
