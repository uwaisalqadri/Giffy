//
//  GiphyItemView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 11/21/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Core
import Giphy
import Common

struct GiphyWidgetItem: View {

  @State private var isAnimating = true
  let giphy: Giphy

  var body: some View {
    VStack(alignment: .leading) {

      AnimatedImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .indicator(SDWebImageActivityIndicator.medium)
        .resizable()
        .frame(idealWidth: (giphy.images.original.width).cgFloatValue(), idealHeight: (giphy.images.original.height).cgFloatValue(), alignment: .center)
        .scaledToFit()
        .cornerRadius(20)
        .padding(.top, 10)
    }
  }
}
