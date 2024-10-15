//
//  GiphyDynamicIsland.swift
//  GiffyWidget
//
//  Created by Uwais Alqadri on 22/10/23.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Common

struct GiffyActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: GiphyAttributes.self) { _ in
      VStack {
        Text("Hello")
      }
      .activityBackgroundTint(Color.cyan)
      .activitySystemActionForegroundColor(Color.black)
      
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          EmptyView()
        }
        DynamicIslandExpandedRegion(.trailing) {
          EmptyView()
        }
        DynamicIslandExpandedRegion(.bottom) {
          IslandExpandedView(title: context.attributes.title)
        }
      } compactLeading: {
        Text("GIF")
      } compactTrailing: {
        IslandTrailingView()
      } minimal: {
        IslandTrailingView()
      }
    }
  }
}

struct IslandTrailingView: View {
  var body: some View {
    HStack {
      LinearGradient(
        colors: [.Theme.purple, .Theme.red],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
      .mask(
        Image(systemName: "heart.fill")
          .resizable()
      )
      .frame(width: 20, height: 18)
      
      Text("!")
    }
  }
}

struct IslandExpandedView: View {
  
  let title: String
  
  var body: some View {
    HStack(alignment: .center, spacing: 20) {
      LinearGradient(
        colors: [.Theme.purple, .Theme.red],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
      .mask(
        Image(systemName: "heart.fill")
          .resizable()
      )
      .frame(width: 50, height: 48)
      
      Text("\(title) ")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.white)
      
      +
      
      Text("is added to your favorite!")
        .font(.headline)
        .fontWeight(.light)
        .foregroundColor(.white)
    }
  }
}
