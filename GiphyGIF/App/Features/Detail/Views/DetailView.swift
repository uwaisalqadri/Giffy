//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct DetailView: View {

  let giphy: Giphy
  @State var isAnimation = true

  var body: some View {
    NavigationView {
      WebView(url: URL(string: giphy.url))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .navigationBarItems(trailing:
          Button(action: {
            print("Oke")
          }) {
           Image(systemName: "heart")
            .resizable()
            .frame(width: 23, height: 20)
            .foregroundColor(.red)
         })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
