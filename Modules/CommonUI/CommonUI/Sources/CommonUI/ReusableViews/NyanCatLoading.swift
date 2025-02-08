//
//  NyanCatLoading.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 15/10/23.
//

import SwiftUI

public struct NyanCatLoading: View {
  private let size: CGFloat
  
  public init(size: CGFloat = 200) {
    self.size = size
  }
  
  public var body: some View {
    LottieView(fileName: "nyan_cat", bundle: Bundle.common, loopMode: .loop)
      .frame(width: size, height: size)
      .padding(.trailing, -40)
  }
}
