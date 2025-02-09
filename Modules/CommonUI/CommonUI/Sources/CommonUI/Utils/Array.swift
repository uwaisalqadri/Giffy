//
//  Array.swift
//  
//
//  Created by Uwais Alqadri on 21/10/23.
//

import Foundation

extension Array {
  public var indexed: [(position: Int, item: Element)] {
    return self.enumerated().map { ($0, $1) }
  }
}
