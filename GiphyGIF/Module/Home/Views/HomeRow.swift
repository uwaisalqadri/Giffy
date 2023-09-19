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

      AnimatedImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .placeholder(content: {
          Color(.randomColor)
        })
        .resizable()
        .frame(
          idealWidth: (giphy.images.original.width).cgFloat,
          idealHeight: (giphy.images.original.height).cgFloat,
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
