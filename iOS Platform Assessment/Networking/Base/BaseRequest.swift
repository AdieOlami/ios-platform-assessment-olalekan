//
//  BaseRequest.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - BaseRequest

protocol BaseRequest {
    var baseUrl: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var method: HTTPRequestMethod { get }
    var parameters: HTTPParameters { get }
}

// MARK: - HTTPRequestMethod

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public typealias HTTPHeaders = [String: String]
public typealias HTTPParameters = [String: Any]?
