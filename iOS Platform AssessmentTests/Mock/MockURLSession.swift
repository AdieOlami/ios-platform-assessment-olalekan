//
//  MockURLSession.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

@testable import iOS_Platform_Assessment

// MARK: - MockURLSession

final class MockURLSession {
    
    // MARK: Internal
    
    static var mockData: Data?
    static var mockResponse: URLResponse?
    static var mockError: Error?
    static var requestCount = 0
    static var lastRequest: URLRequest?
    
    static func reset() {
        mockData = nil
        mockResponse = nil
        mockError = nil
        requestCount = 0
        lastRequest = nil
    }
    
    static func setupSuccessResponse<T: Codable>(_ object: T, statusCode: Int = 200) throws {
        mockData = try JSONEncoder().encode(object)
        mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com/test")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        mockError = nil
    }
    
    static func setupErrorResponse(statusCode: Int, errorData: Data? = nil) {
        mockData = errorData
        mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com/test")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        mockError = nil
    }
    
    static func setupNetworkError(_ error: Error) {
        mockData = nil
        mockResponse = nil
        mockError = error
    }
}
