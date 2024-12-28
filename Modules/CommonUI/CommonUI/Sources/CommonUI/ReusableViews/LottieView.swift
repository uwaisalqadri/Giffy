//
//  LottieView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 06/06/21.
//

import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
  public typealias UIViewType = UIView
  
  var fileName: String
  var bundle: Bundle
  var loopMode: LottieLoopMode
  
  public init(fileName: String, bundle: Bundle, loopMode: LottieLoopMode) {
    self.fileName = fileName
    self.bundle = bundle
    self.loopMode = loopMode
  }
  
  public func makeUIView(context: Context) -> UIView {
    
    let view = UIView(frame: .zero)
    let animationView = LottieAnimationView()
    let animation = LottieAnimation.named(fileName, bundle: bundle)
    animationView.animation = animation
    animationView.contentMode = .scaleAspectFill
    animationView.play()
    animationView.loopMode = loopMode
    
    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)
    
    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    return view
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {}
}
