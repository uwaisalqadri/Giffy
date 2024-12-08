//
//  GifView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 08/12/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct GIFView: View {
  let url: URL?
  var contentMode: ContentMode = .fill
  let options: SDWebImageOptions
  var onSuccess: ((Data?) -> Void)? = nil
  
  var body: some View {
    AnimatedImage(
      url: url,
      options: options,
      isAnimating: .constant(true),
      placeholder: { Color.randomColor }
    )
    .onSuccess { _, data, _ in
      onSuccess?(data)
    }
    .resizable()
    .aspectRatio(contentMode: contentMode)
  }
}

extension GIFView {
  func onSuccess(completion: @escaping (Data?) -> Void) -> Self {
    var newSelf = self
    newSelf.onSuccess = completion
    return newSelf
  }
}
