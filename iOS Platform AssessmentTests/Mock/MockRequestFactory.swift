//
//  MockRequestFactory.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

@testable import iOS_Platform_Assessment

// MARK: - MockRequestFactory

final class MockRequestFactory: RequestFactoryProviding {
    
    // MARK: Internal
    
    var shouldThrowError = false
    var mockResponse: Any?
    var mockError: APIError?
    var requestCallCount = 0
    var lastRequestBuilder: BaseRequest?
    var lastCachePolicy: URLRequest.CachePolicy?
    
    func request<T: Codable>(with builder: BaseRequest, cachePolicy: URLRequest.CachePolicy) async throws -> T {
        lastRequestBuilder = builder
        lastCachePolicy = cachePolicy
        requestCallCount += 1
        
        if shouldThrowError {
            throw mockError ?? APIError.unknown
        }
        
        guard let response = mockResponse as? T else {
            throw APIError.decodingError(underlyingError: NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock response type mismatch"]))
        }
        
        return response
    }
    
    func request<T: Codable>(with builder: BaseRequest, cachePolicy: URLRequest.CachePolicy, customDecoder: JSONDecoder) async throws -> T {
        return try await request(with: builder, cachePolicy: cachePolicy)
    }
    
    func request<T: Codable>(with builder: BaseRequest, customDecoder: JSONDecoder) async throws -> T {
        return try await request(with: builder, cachePolicy: .useProtocolCachePolicy)
    }
    
    func request<T: Codable>(with builder: BaseRequest) async throws -> T {
        return try await request(with: builder, cachePolicy: .useProtocolCachePolicy)
    }
    
    func reset() {
        shouldThrowError = false
        mockResponse = nil
        mockError = nil
        requestCallCount = 0
        lastRequestBuilder = nil
        lastCachePolicy = nil
    }
}
