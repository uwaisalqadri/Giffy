//
//  View+Ext.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI

struct RoundedCornerModifier: Shape {

  public var radius: CGFloat = .infinity
  public var corners: UIRectCorner = .allCorners

  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

extension View {
  public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCornerModifier(radius: radius, corners: corners))
  }
}
