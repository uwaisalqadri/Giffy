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
  let data: Data?
  var contentMode: ContentMode = .fill
  var options: SDWebImageOptions
  @Binding var downloadedImage: Data?
  var onSuccess: ((Data?) -> Void)?
  
  init(
    url: URL? = nil,
    data: Data? = nil,
    contentMode: ContentMode = .fill,
    options: SDWebImageOptions = [.queryMemoryData, .highPriority],
    downloadedImage: Binding<Data?> = .constant(nil),
    onSuccess: ((Data?) -> Void)? = nil
  ) {
    self.url = url
    self.data = data
    self.contentMode = contentMode
    self.options = options
    _downloadedImage = downloadedImage
    self.onSuccess = onSuccess
  }
  
  var body: some View {
    animatedImage
      .onSuccess { _, data, _ in
        onSuccess?(data)
        downloadedImage = data
      }
      .resizable()
      .aspectRatio(contentMode: contentMode)
  }
  
  var animatedImage: AnimatedImage {
    if let data {
      AnimatedImage(
        data: data,
        isAnimating: .constant(true)
      )
    } else {
      AnimatedImage(
        url: url,
        options: options,
        isAnimating: .constant(true),
        placeholder: { Color.randomColor }
      )
    }
  }
}

extension GIFView {
  func onSuccess(completion: @escaping (Data?) -> Void) -> Self {
    var newSelf = self
    newSelf.onSuccess = completion
    return newSelf
  }
}
