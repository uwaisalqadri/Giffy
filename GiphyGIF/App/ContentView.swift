//
//  ContentView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI
import Common

struct ContentView: ViewControllable {

  var holder: Common.NavStackHolder
  
  @State var currentTab = 0

  var body: some View {
    NavigationView {
      ZStack {
        if let viewController = holder.viewController {
          switch currentTab {
          case 0:
            initiateHomeView(viewController: viewController)
          case 1:
            initiateSearchView(viewController: viewController)
          case 2:
            initiateAboutView(viewController: viewController)
          default:
            EmptyView()
          }
        }

        VStack {
          Spacer()
          tabView.padding(.bottom, 20)
        }
      }
    }
  }

  var tabView: some View {
    HStack(spacing: 30) {
      Button(action: {
        currentTab = 0
      }) {
        VStack {
          Image(systemName: "rectangle.3.offgrid")
            .resizable()
            .foregroundColor(.green)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }

      Button(action: {
        currentTab = 1
      }) {
        VStack {
          Image(systemName: "rectangle.stack")
            .resizable()
            .foregroundColor(.yellow)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }

      Button(action: {
        currentTab = 2
      }) {
        VStack {
          Image(systemName: "person")
            .resizable()
            .foregroundColor(.purple)
            .frame(width: 25, height: 25, alignment: .center)
            .padding(5)
        }
      }
    }
    .frame(maxWidth: UIDevice.isIpad ? 300 : .infinity, minHeight: 80)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .cornerRadius(15, corners: [.allCorners])
    )
    .padding(.horizontal, 70)
  }
}

extension ContentView {
  func initiateHomeView(viewController: UIViewController) -> HomeView {
    let view: HomeView = Injection.shared.resolve()
    view.holder.viewController = viewController
    return view
  }
  
  func initiateSearchView(viewController: UIViewController) -> SearchView {
    let view: SearchView = Injection.shared.resolve()
    view.holder.viewController = viewController
    return view
  }
  
  func initiateAboutView(viewController: UIViewController) -> AboutView {
    let view: AboutView = Injection.shared.resolve()
    view.holder.viewController = viewController
    return view
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(holder: Injection.shared.resolve())
  }
}
