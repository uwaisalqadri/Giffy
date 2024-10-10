//
//  Router.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 10/10/24.
//

import Foundation
import SwiftUI

public protocol RouterIdentifiable: Equatable {
  var key: String { get }
}

public final class Router<T: RouterIdentifiable> {
  private var _routes: [T] = []
  public var routes: [T] {
    return _routes
  }

  public var onMakeRoot: ((T, Bool) -> Void)?
  public var onPush: ((T, Bool) -> Void)?
  public var onPresent: ((T, Bool) -> Void)?
  public var onPopLast: ((Int, Bool) -> Void)?
  public var onPopToRoot: ((Int?, Bool) -> Void)?

  public init(initial: T? = nil) {
    if let initial = initial {
      push(initial)
    }
  }

  public func makeRoot(_ route: T, animated: Bool = true, needValidate: Bool = false) {
    if needValidate && _routes.last?.key == route.key {
      return
    }

    _routes = [route]
    onMakeRoot?(route, animated)
  }

  public func push(_ route: T, animated: Bool = true, needValidate: Bool = false) {
    if needValidate && _routes.last?.key == route.key {
      return
    }

    _routes.append(route)
    onPush?(route, animated)
  }

  public func present(_ route: T, animated: Bool = true, needValidate: Bool = false) {
    if needValidate && _routes.last?.key == route.key {
      return
    }

    _routes.append(route)
    onPresent?(route, animated)
  }

  public func pop(animated: Bool = true) {
    if !_routes.isEmpty {
      let popped = _routes.removeLast()
      print("Router \(popped)")
      onPopLast?(1, animated)
    }
  }

  public func popTo(last index: Int, animated: Bool = true) {
    if !_routes.isEmpty {
      let elementsToRemove = min(index - 1, _routes.count - 1)
      _routes.removeLast(elementsToRemove)
      onPopLast?(index, animated)
    }
  }

  public func popTo(_ route: T, inclusive: Bool = false, animated: Bool = true) {

    if _routes.isEmpty {
      return
    }

    guard var found = _routes.lastIndex(where: { $0 == route }) else {
      return
    }

    if !inclusive {
      found += 1
    }

    guard found != 0 else {
      popToRoot()
      return
    }

    let numToPop = (found ..< _routes.endIndex).count
    _routes.removeLast(numToPop)
    onPopLast?(numToPop, animated)
  }

  public func popToRoot(index: Int? = nil, animated: Bool = true) {
    onPopToRoot?(index, animated)
    if _routes.count > 1 {
      _routes.removeSubrange(1 ..< _routes.count)
    }
  }

  public func onSystemPop() {
    if !_routes.isEmpty {
      let popped = _routes.removeLast()
      print("Router \(popped)")
    }
  }
}

public struct RouteProvider<T: RouterIdentifiable, Screen: View>: View {
  private let router: Router<T>

  @ViewBuilder
  private let routeMap: (T) -> Screen

  public init(_ router: Router<T>, @ViewBuilder _ routeMap: @escaping (T) -> Screen) {
    self.router = router
    self.routeMap = routeMap
  }

  public var body: some View {
    NavigationControllerHost(
      router: router,
      routeMap: routeMap
    )
    .edgesIgnoringSafeArea(.top)
    .edgesIgnoringSafeArea(.bottom)
  }
}

struct NavigationControllerHost<T: RouterIdentifiable, Screen: View>: UIViewControllerRepresentable {
  let router: Router<T>

  @ViewBuilder
  var routeMap: (T) -> Screen

  func makeUIViewController(context _: Context) -> PopAwareUINavigationController {
    let navigation = PopAwareUINavigationController()
    navigation.navigationBar.isHidden = true

    navigation.popHandler = {
      router.onSystemPop()
    }
    navigation.stackSizeProvider = {
      router.routes.count
    }

    for path in router.routes {
      navigation.pushViewController(
        UIHostingController(rootView: routeMap(path)), animated: true
      )
    }

    router.onMakeRoot = { route, animated in
      let viewController = UIHostingController(rootView: routeMap(route))
      navigation.setViewControllers([viewController], animated: animated)
    }

    router.onPush = { route, animated in
      navigation.pushViewController(
        UIHostingController(rootView: routeMap(route)), animated: animated
      )
    }

    router.onPresent = { route, animated in
      let viewController = UIHostingController(rootView: routeMap(route))
      viewController.modalPresentationStyle = .overFullScreen
      navigation.present(viewController, animated: animated, completion: nil)
    }

    router.onPopLast = { numToPop, animated in
      if numToPop == navigation.viewControllers.count {
        navigation.viewControllers = []
      } else {
        let popTo = navigation.viewControllers[navigation.viewControllers.count - numToPop - 1]
        navigation.popToViewController(popTo, animated: animated)
      }
    }

    router.onPopToRoot = { tabIndex, animated in
      navigation.popToRootViewController(animated: animated)

      if let tabIndex {
        NotificationCenter.default.post(
          name: NSNotification.Name("shouldOpenTab"),
          object: nil,
          userInfo: ["tabIndex": tabIndex]
        )
      }
    }

    return navigation
  }

  func updateUIViewController(_ navigation: PopAwareUINavigationController, context _: Context) {
    navigation.navigationBar.isHidden = true
  }

  static func dismantleUIViewController(_ navigation: PopAwareUINavigationController, coordinator _: ()) {
    navigation.viewControllers = []
    navigation.popHandler = nil
  }

  typealias UIViewControllerType = PopAwareUINavigationController
}

class PopAwareUINavigationController: UINavigationController, UINavigationControllerDelegate {
  var popHandler: (() -> Void)?
  var stackSizeProvider: (() -> Int)?

  var popGestureBeganController: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }

  func navigationController(
    _ navigationController: UINavigationController,
    didShow _: UIViewController,
    animated _: Bool
  ) {
    if let stackSizeProvider = stackSizeProvider, stackSizeProvider() > navigationController.viewControllers.count {
      popHandler?()
    }
  }
}
