//
//  APIError.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - APIError

enum APIError: Error, Equatable {
    case decodingError(underlyingError: Error)
    case httpError(Int)
    case unknown
    case notRunning
    case invalidResponse
    case server(response: ErrorResponse)

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
    
    // MARK: Equatable
        static func == (lhs: APIError, rhs: APIError) -> Bool {
            switch (lhs, rhs) {
            case (.decodingError(let lhsError), .decodingError(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.httpError(let lhsCode), .httpError(let rhsCode)):
                return lhsCode == rhsCode
            case (.unknown, .unknown),
                 (.notRunning, .notRunning),
                 (.invalidResponse, .invalidResponse):
                return true
            case (.server(let lhsResponse), .server(let rhsResponse)):
                return lhsResponse == rhsResponse
            default:
                return false
            }
        }
}
