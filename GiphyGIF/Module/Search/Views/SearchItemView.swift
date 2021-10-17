//
//  SearchItemView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Giphy
import Common

struct SearchItemView: View {

  @State var isAnimating = true
  @State var showDetail = false
  let giphy: Giphy

  var body: some View {
    ZStack {
      AnimatedImage(url: URL(string: giphy.images?.original?.url ?? ""), isAnimating: $isAnimating)
        .indicator(SDWebImageActivityIndicator.medium)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: 350, maxHeight: 350, alignment: .center)
        .cornerRadius(20)
        .sheet(isPresented: $showDetail) {
//          DetailView(viewModel: assembler.resolve(), giphy: giphy)
        }
        .onTapGesture {
          showDetail.toggle()
        }

      footer
        .padding(.top, 250)
    }
  }

  var footer: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(giphy.title)
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
          .padding(.leading, 15)

        Text(giphy.username == "" ? "Unnamed" : giphy.username)
          .foregroundColor(.white)
          .font(.system(size: 15, weight: .regular))
          .padding(.leading, 15)
      }

      Spacer()

    }.frame(maxWidth: 350, maxHeight: 130)
//    .background(
//      Blur(style: .systemUltraThinMaterialDark)
//        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
//    )
  }
}
