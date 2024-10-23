//
//  GiffyGridRow.swift
//  Giffy
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Core
import Common
import CommonUI

struct GiffyGridRow: View {

  @State private var downloadedImage: Data?
  let giphy: Giffy

  var onTapRow: ((Giffy) -> Void)?

  var body: some View {
    VStack(alignment: .leading) {
      AnimatedImage(
        url: URL(string: giphy.image.url),
        options: .queryMemoryData,
        isAnimating: .constant(true)
      ) {
        Color.randomColor
      }
      .onSuccess { _, data, _ in
        downloadedImage = data
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
      .showGiphyMenu(URL(string: giphy.url), data: downloadedImage)
    }
  }
}
