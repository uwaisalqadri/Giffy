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
      WebImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: 400, maxHeight: 400, alignment: .center)
        .cornerRadius(20)

      footer
        .padding(.top, 180)
    }
  }

  var footer: some View {
    VStack(alignment: .leading) {
      Text(giphy.title)
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .semibold))

      Text(giphy.rating)
        .foregroundColor(.gray)
        .font(.system(size: 15, weight: .semibold))

    }.frame(maxWidth: 350, maxHeight: 80)
    .background(
      RoundedRectangle(cornerRadius: 0)
        .fill(Color.clear)
        .blur(radius: 10)
    )
  }
}

struct SearchItemView_Previews: PreviewProvider {
  static var previews: some View {
    SearchItemView(giphy: Giphy(type: "", id: "", url: "https://media2.giphy.com/media/pfEKZQG1IMHl2trcsL/giphy.gif?cid=acc285bff3pkjsgu883yjffvkktkh5yt5t89l9j0eiw5e0yj&rid=giphy.gif", embedUrl: "", rating: "", username: "", title: "Blogger", trendingDateTime: "", images: ImageGIF(original: Original(url: "", height: "", width: "")))
    ).previewLayout(.sizeThatFits)
  }
}
