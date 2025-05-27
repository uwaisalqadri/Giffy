//
//  APIFactory.swift
//
//
//  Created by Uwais Alqadri on 11/10/24.
//

import Foundation

public protocol APIFactory {
    var path: String { get }
    var parameters: [String: Any] { get }
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var bodyData: Data? { get }
    
    var composedURL: URL { get }
}

public extension APIFactory {
    var composedURL: URL {
        let params = parameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
        let urlString = baseURL.appending(path)
            .appending("?")
            .appending(params)
        return URL(string: urlString) ?? URL.init(fileURLWithPath: "")
    }
}

public enum HTTPMethod {
    case get
    case post(body: Data? = nil)
    case put
    case delete
    case patch
    
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        }
    }
}
