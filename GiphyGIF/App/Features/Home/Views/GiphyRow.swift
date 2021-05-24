//
//  GiphyRow.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct GiphyRow: View {

  @State var isAnimating = false
  let giphy: Giphy

  var body: some View {
    VStack(alignment: .leading) {

      AnimatedImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .indicator(SDWebImageActivityIndicator.medium)
        .customLoopCount(2)
        .playbackRate(2.0)
        .playbackMode(.bounce)
        .renderingMode(.original)
        .resizable()
        .frame(idealWidth: giphy.images.original.width.CGFloatValue(), idealHeight: giphy.images.original.height.CGFloatValue(), alignment: .center)
        .scaledToFit()
        .cornerRadius(20)
        .padding(.top, 10)
    }
  }
}

struct GiphyRow_Previews: PreviewProvider {
  static var previews: some View {
    GiphyRow(giphy: Giphy(type: "", id: "", url: "", embedUrl: "", rating: "", username: "", title: "", trendingDateTime: "", images: Image(original: Original(url: "", height: "", width: "")))
    ).previewLayout(.sizeThatFits)
  }
}
