//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 10/10/23.
//

import SwiftUI

public enum FontType: String, CaseIterable {
  case bold = "Poppins-Bold"
  case semibold = "Poppins-SemiBold"
  case regular = "Poppins-Regular"
  case medium = "Poppins-Medium"
}

public extension SwiftUI.Text {
  func font(_ type: FontType, size: CGFloat) -> Self {
    font(.custom(type.rawValue, size: size))
  }
}

public extension SwiftUI.View {
  func font(_ type: FontType, size: CGFloat) -> some View {
    font(.custom(type.rawValue, size: size))
  }
}

public extension UIFont {
  convenience init?(type: FontType, size: CGFloat) {
    self.init(name: type.rawValue, size: size)
  }
}

public extension Font {
  fileprivate static func custom(type: FontType, size: CGFloat) -> Font {
    return Font.custom(type.rawValue, size: size)
  }
  
  static func loadCustomFont() {
    FontType.allCases.forEach { jbsRegisterFont(withFontType: $0) }
  }
  
  static func jbsRegisterFont(withFontType filename: FontType) {
        
    guard let pathForResourceString = Bundle.common.path(forResource: filename.rawValue, ofType: "ttf") else {
      print("UIFont+:  Failed to register font - path for resource not found.")
      return
    }
    
    guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
      print("UIFont+:  Failed to register font - font data could not be loaded.")
      return
    }
    
    guard let dataProvider = CGDataProvider(data: fontData) else {
      print("UIFont+:  Failed to register font - data provider could not be loaded.")
      return
    }
    
    guard let font = CGFont(dataProvider) else {
      print("UIFont+:  Failed to register font - font could not be loaded.")
      return
    }
    
    var errorRef: Unmanaged<CFError>?
    if CTFontManagerRegisterGraphicsFont(font, &errorRef) == false {
      print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
    }
  }
  
}
