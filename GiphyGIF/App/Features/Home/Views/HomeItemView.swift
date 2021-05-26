//
//  HomeItemView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeItemView: View {

  @State var isAnimating = true
  let giphy: Giphy

  var body: some View {
    VStack(alignment: .leading) {

      AnimatedImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .indicator(SDWebImageActivityIndicator.medium)
        .resizable()
        .frame(idealWidth: giphy.images.original.width.CGFloatValue(), idealHeight: giphy.images.original.height.CGFloatValue(), alignment: .center)
        .scaledToFit()
        .cornerRadius(20)
        .padding(.top, 10)
    }
  }
}

struct HomeItemView_Previews: PreviewProvider {
  static var previews: some View {
    HomeItemView(giphy:
                  Giphy(
                    type: "",
                    id: "",
                    url: "",
                    embedUrl: "",
                    rating: "",
                    username: "",
                    title: "",
                    trendingDateTime: "",
                    images: ImageGIF(original: Original(url: "", height: "", width: "")),
                    favorite: false

                  )
    ).previewLayout(.sizeThatFits)
  }
}
