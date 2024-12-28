//
//  TrackScrollOffset.swift
//
//
//  Created by Uwais Alqadri on 23/10/24.
//

import SwiftUI

public struct ScrollViewOffsetModifier: ViewModifier {
  let onOffsetChange: (CGFloat) -> Void
  
  public init(onOffsetChange: @escaping (CGFloat) -> Void) {
    self.onOffsetChange = onOffsetChange
  }
  
  public func body(content: Content) -> some View {
    content
      .overlay(
        GeometryReader { geo in
          Color.clear
            .preference(
              key: ScrollViewOffsetPreferenceKey.self,
              value: geo.frame(in: .named("scrollView")).minY
            )
        }
      )
      .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
        onOffsetChange(value)
      }
  }
}

public struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  public static var defaultValue: CGFloat = 0
  public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

public extension View {
  func trackScrollOffset(onOffsetChange: @escaping (CGFloat) -> Void) -> some View {
    modifier(ScrollViewOffsetModifier(onOffsetChange: onOffsetChange))
  }
}
