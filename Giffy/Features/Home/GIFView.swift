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
  var options: SDWebImageOptions = [
    .scaleDownLargeImages,
    .queryMemoryData,
    .queryDiskDataSync,
    .progressiveLoad,
    .highPriority
  ]
  var downloadedImage: Binding<Data?> = .constant(nil)
  var onSuccess: ((Data?) -> Void)? = nil
  
  var body: some View {
    AnimatedImage(
      url: url,
      options: options,
      isAnimating: .constant(true),
      placeholder: { Color.randomColor }
    )
    .onSuccess { _, data, _ in
      DispatchQueue.main.async {
        onSuccess?(data)
        downloadedImage.wrappedValue = data
      }
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
