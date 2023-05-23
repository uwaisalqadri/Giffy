//
//  AppDelegate.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 22/5/23.
//

import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private let view = ContentView(holder: Injection.shared.resolve())

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: view.viewController)
    window?.makeKeyAndVisible()

    return true
  }

}
