//
//  GiphyGridRow.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Core
import Common
import CommonUI

struct GiphyGridRow: View {

  @State private var isAnimating = true
  let giphy: Giffy

  var onTapRow: ((Giffy) -> Void)?

  var body: some View {
    VStack(alignment: .leading) {
      AnimatedImage(url: URL(string: giphy.image.url), isAnimating: $isAnimating) {
        Color.randomColor
      }
      .resizable()
      .background(Color.randomColor)
      .frame(
        idealWidth: (giphy.image.width).cgFloat,
        idealHeight: (giphy.image.height).cgFloat,
        alignment: .center
      )
      .scaledToFit()
      .cornerRadius(10)
      .padding(.top, 10)
      .onTapGesture {
        onTapRow?(giphy)
      }
      .showGiphyMenu(URL(string: giphy.url))
    }
  }
}
