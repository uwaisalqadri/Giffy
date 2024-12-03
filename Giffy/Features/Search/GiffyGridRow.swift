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
        options: [.scaleDownLargeImages, .queryMemoryData, .highPriority],
        isAnimating: .constant(true),
        placeholder: { Color.randomColor }
      )
      .onSuccess { _, data, _ in
        downloadedImage = data
      }
      .resizable()
      .showGiphyMenu(URL(string: giphy.image.url), data: downloadedImage, withShape: .rect(cornerRadius: 10))
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
    }
  }
}
