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
        .frame(width: 200, height: 200, alignment: .center)
        .scaledToFit()
        .cornerRadius(10)

      Text(giphy.title)
        .font(.system(size: 15, weight: .medium))
        .padding([.leading, .bottom], 10)
    }
  }
}

struct GiphyRow_Previews: PreviewProvider {
  static var previews: some View {
    GiphyRow(giphy: Giphy(type: "", id: "", url: "", embedUrl: "", rating: "", username: "", title: "", trendingDateTime: "", images: Image(original: Original(url: "", height: "", width: "")))
    ).previewLayout(.sizeThatFits)
  }
}
