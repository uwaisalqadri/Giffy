//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation

public protocol ImageGIF {
  var original: Original? { get }
}

public protocol Original {
  var url: String { get }
  var height: String { get }
  var width: String { get }
}
