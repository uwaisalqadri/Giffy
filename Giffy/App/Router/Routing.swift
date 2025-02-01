//
//  Routing.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import SwiftUI

public protocol RouterIdentifiable: Equatable {
  var key: String { get }
}

public final class Routing<T: RouterIdentifiable> {
  private var routes: [T] = []
  public var onMakeRoot: ((T, Bool) -> Void)?
  public var onPush: ((T, Bool) -> Void)?
  public var onPresent: ((T, Bool) -> Void)?
  public var onPopLast: ((Int, Bool) -> Void)?
  public var onPopToRoot: ((Int?, Bool) -> Void)?
  
  public var currentRoutes: [T] {
    return routes
  }
  
  public init(initial: T? = nil) {
    if let initial = initial { push(initial) }
  }
  
  public func makeRoot(_ route: T, animated: Bool = true, needValidate: Bool = false) {
    guard !(needValidate && routes.last?.key == route.key) else { return }
    routes = [route]
    onMakeRoot?(route, animated)
  }
  
  public func push(_ route: T, animated: Bool = true, needValidate: Bool = false) {
    guard !(needValidate && routes.last?.key == route.key) else { return }
    routes.append(route)
    print("Routing pushed: \(route)")
    onPush?(route, animated)
  }
  
  public func present(_ route: T, animated: Bool = true, needValidate: Bool = false) {
    guard !(needValidate && routes.last?.key == route.key) else { return }
    routes.append(route)
    print("Routing presented: \(route)")
    onPresent?(route, animated)
  }
  
  public func pop(animated: Bool = true) {
    guard !routes.isEmpty else { return }
    let popped = routes.removeLast()
    print("Routing popped: \(popped)")
    onPopLast?(1, animated)
  }
  
  public func popTo(last index: Int, animated: Bool = true) {
    guard !routes.isEmpty else { return }
    let elementsToRemove = min(index - 1, routes.count - 1)
    routes.removeLast(elementsToRemove)
    onPopLast?(index, animated)
  }
  
  public func popTo(_ route: T, inclusive: Bool = false, animated: Bool = true) {
    guard let foundIndex = routes.lastIndex(where: { $0 == route }) else { return }
    let indexToPopTo = inclusive ? foundIndex : foundIndex + 1
    guard indexToPopTo != 0 else {
      popToRoot(index: nil, animated: animated)
      return
    }
    
    let numToPop = routes.count - indexToPopTo
    routes.removeLast(numToPop)
    onPopLast?(numToPop, animated)
  }
  
  public func popToRoot(index: Int? = nil, animated: Bool = true) {
    onPopToRoot?(index, animated)
    if routes.count > 1 {
      routes.removeSubrange(1 ..< routes.count)
    }
  }
  
  public func onSystemPop() {
    guard !routes.isEmpty else { return }
    let popped = routes.removeLast()
    print("Routing popped: \(popped)")
  }
}

public struct RouteProvider<T: RouterIdentifiable, Screen: View>: View {
  private let router: Routing<T>
  @ViewBuilder private let routeMap: (T) -> Screen
  
  public init(_ router: Routing<T>, @ViewBuilder _ routeMap: @escaping (T) -> Screen) {
    self.router = router
    self.routeMap = routeMap
  }
  
  public var body: some View {
    NavigationControllerHost(router: router, routeMap: routeMap)
      .edgesIgnoringSafeArea(.all)
  }
}

struct NavigationControllerHost<T: RouterIdentifiable, Screen: View>: UIViewControllerRepresentable {
  let router: Routing<T>
  @ViewBuilder var routeMap: (T) -> Screen
  
  func makeUIViewController(context: Context) -> PopAwareUINavigationController {
    let navigation = PopAwareUINavigationController()
    navigation.navigationBar.isHidden = true
    setupRouterCallbacks(in: navigation)
    setupInitialRoutes(in: navigation)
    return navigation
  }
  
  private func setupRouterCallbacks(in navigation: PopAwareUINavigationController) {
    navigation.popHandler = { router.onSystemPop() }
    navigation.stackSizeProvider = { router.currentRoutes.count }
    
    router.onMakeRoot = { route, animated in
      let viewController = UIHostingController(rootView: routeMap(route))
      navigation.setViewControllers([viewController], animated: animated)
    }
    
    router.onPush = { route, animated in
      let viewController = UIHostingController(rootView: routeMap(route))
      navigation.pushViewController(viewController, animated: animated)
    }
    
    router.onPresent = { route, animated in
      let viewController = UIHostingController(rootView: routeMap(route))
      viewController.modalPresentationStyle = .overFullScreen
      rootViewController?.present(viewController, animated: animated)
    }
    
    router.onPopLast = { numToPop, animated in
      let popTo = navigation.viewControllers.count - numToPop - 1
      if numToPop == navigation.viewControllers.count {
        navigation.viewControllers = []
      } else {
        navigation.popToViewController(navigation.viewControllers[popTo], animated: animated)
      }
    }
    
    router.onPopToRoot = { tabIndex, animated in
      navigation.popToRootViewController(animated: animated)
      if let tabIndex = tabIndex {
        NotificationCenter.default.post(
          name: NSNotification.Name("shouldOpenTab"),
          object: nil,
          userInfo: ["tabIndex": tabIndex]
        )
      }
    }
  }
  
  private var rootViewController: UIViewController? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .compactMap { $0.windows.first { $0.isKeyWindow } }
      .first?.rootViewController.flatMap(getTopViewController)
  }
  
  private func getTopViewController(from viewController: UIViewController) -> UIViewController {
    if let presented = viewController.presentedViewController {
      return getTopViewController(from: presented)
    } else if let navigation = viewController as? UINavigationController {
      return getTopViewController(from: navigation.visibleViewController ?? viewController)
    } else if let tabBar = viewController as? UITabBarController {
      return getTopViewController(from: tabBar.selectedViewController ?? viewController)
    } else {
      return viewController
    }
  }
  
  private func setupInitialRoutes(in navigation: PopAwareUINavigationController) {
    for path in router.currentRoutes {
      navigation.pushViewController(UIHostingController(rootView: routeMap(path)), animated: true)
    }
  }
  
  func updateUIViewController(_ navigation: PopAwareUINavigationController, context: Context) {
    navigation.navigationBar.isHidden = true
  }
  
  static func dismantleUIViewController(_ navigation: PopAwareUINavigationController, coordinator: ()) {
    navigation.viewControllers = []
    navigation.popHandler = nil
  }
  
  typealias UIViewControllerType = PopAwareUINavigationController
}

class PopAwareUINavigationController: UINavigationController, UINavigationControllerDelegate {
  var popHandler: (() -> Void)?
  var stackSizeProvider: (() -> Int)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
    if let stackSizeProvider = stackSizeProvider, stackSizeProvider() > navigationController.viewControllers.count {
      popHandler?()
    }
  }
}
