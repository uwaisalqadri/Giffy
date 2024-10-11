//
//  APIFactory.swift
//
//
//  Created by Uwais Alqadri on 11/10/24.
//

import Foundation

public protocol APIFactory {
    var path: String { get }
    var parameter: [String: Any] { get }
    var composedURL: URL { get }
    var baseURL: String { get }
}
