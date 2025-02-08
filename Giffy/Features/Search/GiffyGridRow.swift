//
//  GiffyGridRow.swift
//  Giffy
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Core
import Common
import CommonUI

struct GiffyGridRow: View {

  @State private var downloadedImage: Data?
  @State private var isShowShare = false
  let giphy: Giffy
  
  var onTapRow: ((Giffy) -> Void)?
  var onShare: ((Data?) -> Void)?
  
  var body: some View {
    VStack(alignment: .leading) {
      GIFView(
        data: giphy.image.data,
        downloadedImage: $downloadedImage
      )
      .showGiffyMenu(
        URL(string: giphy.image.url),
        data: downloadedImage,
        withShape: .rect(cornerRadius: 10),
        onShowShare: onShare
      )
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
