//
//  HomeRow.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Core
import Giphy
import Common

struct HomeRow: View {

  @State private var isAnimating = true
  let giphy: Giphy
  
  var onTapRow: ((Giphy) -> Void)?

  var body: some View {
    VStack(alignment: .leading) {

      AnimatedImage(url: URL(string: giphy.image.url), isAnimating: $isAnimating)
        .placeholder(content: {
          Color(.randomColor)
        })
        .resizable()
        .frame(
          idealWidth: (giphy.image.width).cgFloat,
          idealHeight: (giphy.image.height).cgFloat,
          alignment: .center
        )
        .scaledToFit()
        .cornerRadius(20)
        .padding(.top, 10)
        .onTapGesture {
          onTapRow?(giphy)
        }
    }
  }
}
