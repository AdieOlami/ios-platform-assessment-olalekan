//
//  ErrorResponse.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - ErrorResponse

struct ErrorResponse: Codable, Equatable {
    let title: String
    let detail: String
}
