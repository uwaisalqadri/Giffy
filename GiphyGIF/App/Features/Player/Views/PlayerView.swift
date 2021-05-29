//
//  PlayerView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct PlayerView: View {

  let giphy: Giphy
  @Binding var showPlayer: Bool
  @State var isAnimation = true

  var body: some View {
    WebView(url: URL(string: giphy.url))
      .edgesIgnoringSafeArea([.bottom, .horizontal])
      .navigationBarItems(trailing:
        Button(action: {
          print("Oke")
        }) {
         Image(systemName: "heart")
          .foregroundColor(.red)
       }
    )
  }
}
