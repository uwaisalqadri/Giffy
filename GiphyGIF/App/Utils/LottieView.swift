//
//  LottieView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 06/06/21.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
  typealias UIViewType = UIView
  
  var fileName: String
  var bundle: Bundle
  var loopMode: LottieLoopMode
  
  func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
    
    let view = UIView(frame: .zero)
    let animationView = LottieAnimationView()
    let animation = LottieAnimation.named(fileName)
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
  
  func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {
    
  }
}
