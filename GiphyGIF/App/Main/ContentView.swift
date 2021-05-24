//
//  ContentView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI

struct ContentView: View {

  let assembler = AppAssembler()

  var body: some View {
    TabView {
      HomeView(viewModel: assembler.resolve())
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      SearchView(viewModel: assembler.resolve())
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
