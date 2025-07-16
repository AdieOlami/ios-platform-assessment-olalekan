//
//  MockBaseRequest.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

@testable import iOS_Platform_Assessment

// MARK: - MockBaseRequest

struct MockBaseRequest: BaseRequest {
    let baseUrl = "api.example.com"
    let path = "test/endpoint"
    let method: HTTPRequestMethod = .get
    let headers: [String: String] = ["Content-Type": "application/json"]
    let parameters: [String: Any]? = ["key": "value"]
}

// MARK: - MockSuccessResponse

struct MockSuccessResponse: Codable, Equatable {
    let id: Int
    let name: String
    let status: String
}

// MARK: - MockErrorResponse

struct MockErrorResponse: Codable, Equatable {
    let error: String
    let code: Int
}
