//
//  APIError.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - APIError

enum APIError: Error {
    case decodingError(underlyingError: Error)
    case httpError(Int)
    case unknown
    case notRunning
    case invalidResponse
    case server(response: BaseResponse)
    case cacheMiss

    var title: String {
        switch self {
        case .server(let response): return response.title
        default:
            return ""
        }
    }

    var description: String {
        switch self {
        case .server(let response): return response.detail
        default:
            return ""
        }
    }
}
