//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import ActivityKit
import Core
import Common
import CommonUI
import ComposableArchitecture
import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
  let store: StoreOf<DetailReducer>

  @Environment(\.dismiss) private var dismiss
  @State private var isAnimating = true
  @State private var activity: Activity<GiphyAttributes>?

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        ZStack(alignment: .bottomTrailing) {
          TabView {
            ForEach(
              Array(repeating: viewStore.state.item, count: 4).indexed,
              id: \.position
            ) { position, item in
              GeometryReader { geometry in
                let mainFrame = geometry.frame(in: .global)
                
                ScrollView(showsIndicators: false) {
                  ZStack {
                    AnimatedGradientBackground()
                      .frame(width: mainFrame.width, height: mainFrame.height)

                    AnimatedImage(url: URL(string: item.image.url), isAnimating: $isAnimating) {
                      Color.randomColor
                    }
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(.degrees(CGFloat(90 * position)))
                    .frame(width: mainFrame.width - 60, height: mainFrame.width - 60)
                    .cornerRadius(20)
                    .showGiphyMenu(item)
                  }
                }
                .frame(width: mainFrame.width, height: mainFrame.height)
                .rotation3DEffect(
                  .init(degrees: getAngle(xOffset: mainFrame.minX, in: mainFrame.width)),
                  axis: (x: 0.0, y: 1.0, z: 0.0),
                  anchor: mainFrame.minX > 0 ? .leading : .trailing,
                  perspective: 2.5
                )
              }
            }
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.top, -40)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
          viewStore.send(.checkFavorite)
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            IconButton(
              iconName: "xmark",
              tint: .Theme.yellow,
              onClick: {
                dismiss()
              }
            )
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            if viewStore.state.isLoading {
              ActivityIndicator(style: .medium)
                .frame(width: 10, height: 10)
                .padding(.trailing, 20)
            } else {
              IconButton(
                iconName: viewStore.state.isShareGIF ? "doc.on.clipboard.fill" : "doc.on.clipboard",
                tint: .Theme.green,
                size: 15,
                onClick: {
                  viewStore.send(.download)
                }
              )
              .tapScaleEffect()
              .padding(.trailing, 20)
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            IconButton(
              iconName: viewStore.state.isFavorited ? "heart.fill" : "heart",
              tint: .Theme.blueSky,
              onClick: {
                if viewStore.state.isFavorited {
                  viewStore.send(.removeFavorite)
                } else {
                  viewStore.send(.addFavorite)
                  viewStore.send(.startLiveActivity(viewStore.state))
                }
              }
            ).tapScaleEffect()
          }
        }
      }
    }
  }

  func getAngle(xOffset: CGFloat, in screenWidth: CGFloat) -> Double {
    let angle = xOffset / (screenWidth / 2)
    let rotationDegree: CGFloat = 25
    return Double(angle * rotationDegree)
  }
}
