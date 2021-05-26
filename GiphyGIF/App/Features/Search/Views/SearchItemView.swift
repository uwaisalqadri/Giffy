//
//  SearchItemView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchItemView: View {

  @State var isAnimating = true
  let giphy: Giphy

  var body: some View {
    ZStack {
      AnimatedImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .indicator(SDWebImageActivityIndicator.medium)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: 350, maxHeight: 350, alignment: .center)
        .cornerRadius(20)

      footer
        .padding(.top, 300)
    }
  }

  var footer: some View {
    VStack(alignment: .leading) {

      Text(giphy.title)
        .foregroundColor(.white)
        .font(.system(size: 20, weight: .bold))

    }.frame(maxWidth: 350, maxHeight: 100)
    .background(
      Blur(style: .systemUltraThinMaterial)
        //.opacity(0.8)
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
    )
  }
}

struct SearchItemView_Previews: PreviewProvider {
  static var previews: some View {
    SearchItemView(giphy: Giphy(type: "", id: "", url: "https://media2.giphy.com/media/pfEKZQG1IMHl2trcsL/giphy.gif?cid=acc285bff3pkjsgu883yjffvkktkh5yt5t89l9j0eiw5e0yj&rid=giphy.gif", embedUrl: "", rating: "", username: "", title: "Blogger", trendingDateTime: "", images: ImageGIF(original: Original(url: "", height: "", width: "")), favorite: false)
    ).previewLayout(.sizeThatFits)
  }
}
