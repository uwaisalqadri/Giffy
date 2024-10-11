//
//  Toaster.swift
//
//
//  Created by Uwais Alqadri on 11/10/24.
//

import SwiftUI
import UIKit

/// A `Toaster` displays a temporary message at the top of the screen.
///
/// The `Toaster` class provides a way to show non-intrusive messages that can be dismissed by tapping.
/// It supports different styles, such as `success` and `error`, and can be customized in terms of size and duration.
/// It also supports different size, such as `fit` and `fill`, and can be customized in terms of size and duration.
///
/// ## Usage Example:
///
/// ```swift
/// Toaster.success(message: "This is a success message").show()
/// // or
/// Toaster.error(message: "This is an error message").show()
/// ```
///
/// You can specify the size and duration if needed:
///
/// ```swift
/// Toaster.success(message: "This is a success message", size: .wrap, duration: .short).show()
/// ```

public class Toaster: UIView {
  public var message: String
  public var style: TopToast.Style
  public var size: TopToast.Size
  private let duration: Duration
  private var dismissTimer: Timer?
  private var topConstraint: NSLayoutConstraint?
  
  private lazy var toastView: UIView = {
    let toastView = TopToast(title: message, style: style, show: .constant(true), size: size)
    return UIHostingController(rootView: toastView).view
  }()
  
  private init(message: String, duration: Duration, style: TopToast.Style, size: TopToast.Size) {
    self.message = message
    self.duration = duration
    self.style = style
    self.size = size
    super.init(frame: .zero)
    setupView()
    setupTapGesture()
  }
  
  public required init?(coder _: NSCoder) {
    return nil
  }
  
  public static func success(message: String, size: TopToast.Size = .fit, duration: Duration = .long) -> Toaster {
    return make(message: message, style: .success, size: size, duration: duration)
  }
  
  public static func error(message: String, size: TopToast.Size = .fit, duration: Duration = .long) -> Toaster {
    return make(message: message, style: .error, size: size, duration: duration)
  }
  
  private static func make(
    message: String,
    style: TopToast.Style,
    size: TopToast.Size,
    duration: Duration
  ) -> Toaster {
    removeOldViews()
    return Toaster(message: message, duration: duration, style: style, size: size)
  }
  
  public func show() {
    setupConstraints()
    animate(with: 20) { _ in
      if self.duration != .infinite {
        self.dismissTimer = Timer.scheduledTimer(
          timeInterval: TimeInterval(self.duration.value),
          target: self, selector: #selector(self.dismiss),
          userInfo: nil, repeats: false
        )
      }
    }
  }
  
  @objc public func dismiss() {
    invalidateDismissTimer()
    animate(with: -200) { _ in
      self.removeFromSuperview()
    }
  }
  
  private func setupView() {
    backgroundColor = .clear
    toastView.backgroundColor = .clear
    addSubview(toastView)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      toastView.topAnchor.constraint(equalTo: topAnchor),
      toastView.leadingAnchor.constraint(equalTo: leadingAnchor),
      toastView.trailingAnchor.constraint(equalTo: trailingAnchor),
      toastView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func setupConstraints() {
    guard let contextView = Self.contextView else { return }
    
    contextView.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: contextView.leadingAnchor, constant: 16),
      trailingAnchor.constraint(equalTo: contextView.trailingAnchor, constant: -16),
      centerXAnchor.constraint(equalTo: contextView.centerXAnchor),
      heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
    ])
    
    contextView.layoutIfNeeded()
    
    topConstraint = topAnchor.constraint(equalTo: contextView.safeAreaLayoutGuide.topAnchor, constant: -200)
    topConstraint?.isActive = true
  }
  
  private func animate(with offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(
      withDuration: 0.3,
      delay: 0.0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 1.5,
      options: .curveEaseInOut,
      animations: {
        self.topConstraint?.constant = offset
        self.superview?.layoutIfNeeded()
      },
      completion: completion
    )
  }
  
  private func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionDismiss))
    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(actionDismiss))
    swipeGesture.direction = [.up]
    [tapGesture, swipeGesture].forEach {
      addGestureRecognizer($0)
    }
  }
  
  @objc private func actionDismiss(_: Any) {
    dismiss()
  }
  
  private static func removeOldViews() {
    Self.contextView?.subviews
      .compactMap { $0 as? Toaster }
      .forEach { $0.removeFromSuperview() }
  }
  
  private static var contextView: UIView? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .compactMap { $0.windows.first { $0.isKeyWindow } }
      .first?.rootViewController.flatMap(getTopViewController)?.view
  }
  
  private static func getTopViewController(from viewController: UIViewController) -> UIViewController {
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
  
  private func invalidateDismissTimer() {
    dismissTimer?.invalidate()
    dismissTimer = nil
  }
}

public extension Toaster {
  enum Duration: Equatable {
    case long
    case short
    case infinite
    case custom(CGFloat)
    
    var value: CGFloat {
      switch self {
      case .long:
        return 3
      case .short:
        return 2
      case .infinite:
        return -1
      case let .custom(duration):
        return duration
      }
    }
  }
}

public struct TopToast: View {
  public var title: String
  public var style: Style
  public var size: Size
  
  @Binding public var show: Bool
  
  public init(title: String, style: Style, show: Binding<Bool>, size: Size = .fill) {
    self.title = title
    self.style = style
    self.size = size
    _show = show
  }
  
  public var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 8) {
        Image(systemName: style.imageName)
          .foregroundColor(style.color)
        Text(title)
          .font(.system(size: 18, weight: .bold))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        if size == .fill {
          Spacer()
        }
      }
      .padding(16)
      .background(Color.black)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      Spacer()
    }
  }
}

public extension TopToast {
  enum Style {
    case error
    case success
    
    var imageName: String {
      switch self {
      case .error:
        return "xmark"
      case .success:
        return "checkmark"
      }
    }
    
    var color: Color {
      switch self {
      case .error:
        return .red
      case .success:
        return .green
      }
    }
  }
  
  enum Size {
    case fit
    case fill
  }
}

public struct TopToastParams {
  public let title: String
  public let style: TopToast.Style
  public init(title: String, style: TopToast.Style) {
    self.title = title
    self.style = style
  }
}
