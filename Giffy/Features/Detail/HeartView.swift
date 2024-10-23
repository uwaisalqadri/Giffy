//
//  HeartView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 23/10/24.
//

import SwiftUI

public struct HeartModel: Hashable, Identifiable {
  public var id = UUID()
  public var location: CGPoint
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

struct HeartView: View {
  let heart: HeartModel
  @State var isShowHeart: Bool = false
  @State var shouldFly: Bool = false
  
  var body: some View {
    GeometryReader { reader in
      ZStack {
        Image(systemName: "heart.fill")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundStyle(.linearGradient(
            colors: [.Theme.blueSky, .blue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ))
          .bounceSymbol(value: isShowHeart)
          .opacity(isShowHeart ? 1 : 0)
          .offset(
            x: shouldFly ? (reader.size.width / 2 - 40) : heart.location.x - 50,
            y: shouldFly ? (heart.location.y - reader.size.height) : heart.location.y
          )
          .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
              isShowHeart.toggle()
            }
            withAnimation(.snappy(duration: 0.5).delay(0.6)) {
              shouldFly.toggle()
            }
          }
      }
    }
    .ignoresSafeArea(edges: .all)
  }
}

extension View {
  func bounceSymbol(value: Bool) -> some View {
    if #available(iOS 17.0, *) {
      return self.symbolEffect(.bounce, value: value)
    } else {
      return self
    }
  }
}
