//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 10/10/23.
//

import SwiftUI

public enum FontType: String {
  case helveticaBold = "HelveticaNeue-Bold"
  case helveticaSemibold = "HelveticaNeue-Medium"
  case helveticaRegular = "HelveticaNeue-Light"
}

public extension Font {
  
  struct HelveticaNeue {
    public static let display1Regular = Font.custom(type: .helveticaRegular, size: 64)
    public static let display1Semibold = Font.custom(type: .helveticaSemibold, size: 64)
    public static let display1Bold = Font.custom(type: .helveticaBold, size: 64)
    
    public static let display2Regular = Font.custom(type: .helveticaRegular, size: 56)
    public static let display2Semibold = Font.custom(type: .helveticaSemibold, size: 56)
    public static let display2Bold = Font.custom(type: .helveticaBold, size: 56)
    
    public static let display3Regular = Font.custom(type: .helveticaRegular, size: 48)
    public static let display3Semibold = Font.custom(type: .helveticaSemibold, size: 48)
    public static let display3Bold = Font.custom(type: .helveticaBold, size: 48)
    
    public static let h1HeadingRegular = Font.custom(type: .helveticaRegular, size: 36)
    public static let h1HeadingSemibold = Font.custom(type: .helveticaSemibold, size: 36)
    public static let h1HeadingBold = Font.custom(type: .helveticaBold, size: 36)
    
    public static let h2HeadingRegular = Font.custom(type: .helveticaRegular, size: 36)
    public static let h2HeadingSemibold = Font.custom(type: .helveticaSemibold, size: 36)
    public static let h2HeadingBold = Font.custom(type: .helveticaBold, size: 36)
    
    public static let h3HeadingRegular = Font.custom(type: .helveticaRegular, size: 30)
    public static let h3HeadingSemibold = Font.custom(type: .helveticaSemibold, size: 30)
    public static let h3HeadingBold = Font.custom(type: .helveticaBold, size: 30)
    
    public static let h4HeadingRegular = Font.custom(type: .helveticaRegular, size: 26)
    public static let h4HeadingSemibold = Font.custom(type: .helveticaSemibold, size: 26)
    public static let h4HeadingBold = Font.custom(type: .helveticaBold, size: 26)
    
    public static let h5HeadingRegular = Font.custom(type: .helveticaRegular, size: 22)
    public static let h5HeadingSemibold = Font.custom(type: .helveticaSemibold, size: 22)
    public static let h5HeadingBold = Font.custom(type: .helveticaBold, size: 22)
    
    public static let h6HeadingRegular = Font.custom(type: .helveticaRegular, size: 18)
    public static let h6HeadingSemibold = Font.custom(type: .helveticaSemibold, size: 18)
    public static let h6HeadingBold = Font.custom(type: .helveticaBold, size: 18)
    
    public static let s1SubtitleRegular = Font.custom(type: .helveticaRegular, size: 15)
    public static let s1SubtitleSemibold = Font.custom(type: .helveticaSemibold, size: 15)
    public static let s1SubtitleBold = Font.custom(type: .helveticaBold, size: 15)
    
    public static let s2SubtitleRegular = Font.custom(type: .helveticaRegular, size: 13)
    public static let s2SubtitleSemibold = Font.custom(type: .helveticaSemibold, size: 13)
    public static let s2SubtitleBold = Font.custom(type: .helveticaBold, size: 13)
    
    public static let p1ParagraphRegular = Font.custom(type: .helveticaRegular, size: 15)
    public static let p1ParagraphSemibold = Font.custom(type: .helveticaSemibold, size: 15)
    public static let p1ParagraphBold = Font.custom(type: .helveticaBold, size: 15)
    
    public static let p2ParagraphRegular = Font.custom(type: .helveticaRegular, size: 13)
    public static let p2ParagraphSemibold = Font.custom(type: .helveticaSemibold, size: 13)
    public static let p2ParagraphBold = Font.custom(type: .helveticaBold, size: 13)
    
    public static let captionRegular = Font.custom(type: .helveticaRegular, size: 12)
    public static let captionSemibold = Font.custom(type: .helveticaSemibold, size: 12)
    public static let captionBold = Font.custom(type: .helveticaBold, size: 12)
    
    public static let labelRegular = Font.custom(type: .helveticaRegular, size: 12)
    public static let labelSemibold = Font.custom(type: .helveticaSemibold, size: 12)
    public static let labelBold = Font.custom(type: .helveticaBold, size: 12)
    
    public static let buttonGiantRegular = Font.custom(type: .helveticaRegular, size: 18)
    public static let buttonGiantSemibold = Font.custom(type: .helveticaSemibold, size: 18)
    public static let buttonGiantBold = Font.custom(type: .helveticaBold, size: 18)
    
    public static let buttonLargeRegular = Font.custom(type: .helveticaRegular, size: 16)
    public static let buttonLargeSemibold = Font.custom(type: .helveticaSemibold, size: 16)
    public static let buttonLargeBold = Font.custom(type: .helveticaBold, size: 16)
    
    public static let buttonMediumRegular = Font.custom(type: .helveticaRegular, size: 14)
    public static let buttonMediumSemibold = Font.custom(type: .helveticaSemibold, size: 14)
    public static let buttonMediumBold = Font.custom(type: .helveticaBold, size: 14)
    
    public static let buttonSmallRegular = Font.custom(type: .helveticaRegular, size: 12)
    public static let buttonSmallSemibold = Font.custom(type: .helveticaSemibold, size: 12)
    public static let buttonSmallBold = Font.custom(type: .helveticaBold, size: 12)
    
    public static let buttonTinyRegular = Font.custom(type: .helveticaRegular, size: 10)
    public static let buttonTinySemibold = Font.custom(type: .helveticaSemibold, size: 10)
    public static let buttonTinyBold = Font.custom(type: .helveticaBold, size: 10)
  }
}

public extension Font {
  fileprivate static func custom(type: FontType, size: CGFloat) -> Font {
    return Font.custom(type.rawValue, size: size)
  }
  
  static func loadCustomFont() {
    self.jbsRegisterFont(withFilename: FontType.helveticaBold)
    self.jbsRegisterFont(withFilename: FontType.helveticaRegular)
    self.jbsRegisterFont(withFilename: FontType.helveticaSemibold)
  }
  
  static func jbsRegisterFont(withFilename filename: FontType) {
        
    guard let pathForResourceString = Bundle.main.path(forResource: filename.rawValue, ofType: "ttf") else {
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
