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

struct DetailView: View {
  let store: StoreOf<DetailReducer>

  @AppStorage("copyCount", store: UserDefaults(suiteName: "com.uwaisalqadri.giffo")) var copyCount: Int = 0
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        ZStack(alignment: .bottomTrailing) {
          TabView(selection: viewStore.binding(
            get: { $0.item },
            send: { .updateHighlight($0) }
          )) {
            ForEach(viewStore.items.indexed, id: \.position) { position, item in
              GeometryReader { geometry in
                let mainFrame = geometry.frame(in: .global)
                let imageWidth = (item.image.width).cgFloat * 1.5
                let imageHeight = (item.image.height).cgFloat * 1.5
                
                ScrollView(showsIndicators: false) {
                  ZStack {
                    AnimatedGradientBackground()
                      .frame(width: mainFrame.width, height: mainFrame.height)
                      .cornerRadius(40)

                    GIFView(
                      url: URL(string: item.image.url),
                      options: [.scaleDownLargeImages, .queryMemoryData, .highPriority]
                    )
                    .onSuccess { data in
                      viewStore.send(.downloaded(data: data))
                    }
                    .scaledToFill()
                    .frame(
                      maxWidth: imageWidth,
                      maxHeight: imageHeight
                    )
                    .clipShape(.rect(cornerRadius: 20))
                    .showGiphyMenu(
                      URL(string: item.url),
                      data: viewStore.downloadedImage,
                      withShape: .rect(cornerRadius: 20)
                    )
                  }
                  .trackScrollOffset { offset in
                    if (50...70).contains(offset) {
                        dismissSheet()
                    }
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
              .tag(item)
            }
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .overlay(
          ZStack {
            ForEach(viewStore.hearts) { heart in
              HeartView(heart: heart)
            }
          }
        )
        .onTapGesture(count: 2) { location in
          viewStore.send(.displayHeart(location: location))
          viewStore.send(.addFavorite)
        }
        .padding(.top, -(window?.safeAreaInsets.top ?? 0))
        .padding(.bottom, -(window?.safeAreaInsets.bottom ?? 0))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
          viewStore.send(.checkFavorite)
        }
        .onDisappear {
          viewStore.send(.onDisappear)
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            IconButton(
              iconName: "chevron.down",
              tint: .Theme.yellow,
              onClick: {
                dismissSheet()
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
                  copyCount += 1
                  viewStore.send(.copyToClipboard)
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
                  
                  let middleX: CGFloat = CGFloat((window?.screen.bounds.width ?? 0.0) / 2)
                  let middleY: CGFloat = CGFloat((window?.screen.bounds.height ?? 0.0) / 2)
                  viewStore.send(.displayHeart(location: .init(x: middleX, y: middleY)))
                }
              }
            )
            .animation(.easeInOut(duration: 0.2), value: viewStore.state.isFavorited)
            .tapScaleEffect()
          }
        }
      }
    }
  }
  
  func dismissSheet() {
    dismiss()
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }

  func getAngle(xOffset: CGFloat, in screenWidth: CGFloat) -> Double {
    let angle = xOffset / (screenWidth / 2)
    let rotationDegree: CGFloat = 25
    return Double(angle * rotationDegree)
  }
}
