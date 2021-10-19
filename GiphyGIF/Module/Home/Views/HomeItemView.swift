//
//  HomeItemView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Core
import Giphy

struct HomeItemView: View {

  @State var isAnimating = true
  @State var showDetail = false
  let giphy: Giphy

  var body: some View {
    VStack(alignment: .leading) {

      AnimatedImage(url: URL(string: giphy.images?.original?.url ?? ""), isAnimating: $isAnimating)
        .indicator(SDWebImageActivityIndicator.medium)
        .resizable()
        .frame(idealWidth: (giphy.images?.original?.width ?? "").cgFloatValue(), idealHeight: (giphy.images?.original?.height ?? "").cgFloatValue(), alignment: .center)
        .scaledToFit()
        .cornerRadius(20)
        .padding(.top, 10)
        .sheet(isPresented: $showDetail) {
          DetailView(giphy: giphy)
        }
        .onTapGesture {
          showDetail.toggle()
        }
    }
  }
}
