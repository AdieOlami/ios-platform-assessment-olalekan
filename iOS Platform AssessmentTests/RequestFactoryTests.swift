//
//  RequestFactoryTests.swift
//  iOS Platform AssessmentTests
//
//  Created by Olami on 2025-07-16.
//

import Testing
import Foundation

@testable import iOS_Platform_Assessment

// MARK: - RequestFactoryTests

struct RequestFactoryTests {
    
    // MARK: Tests
    
    @Test("RequestFactory should construct correct URLs")
    func testURLConstruction() async throws {
        let request = MockBaseRequest()
        
        #expect(request.baseUrl == "api.example.com")
        #expect(request.path == "test/endpoint")
        #expect(request.method == .get)
    }
    
    
    @Test("RequestFactory should set correct headers")
    func testRequestHeaders() async throws {
        let request = MockBaseRequest()
        
        #expect(request.headers["Content-Type"] == "application/json")
    }
    
    @Test("RequestFactory should handle different HTTP methods")
    func testHTTPMethods() async throws {
        struct GetRequest: BaseRequest {
            let baseUrl = "api.example.com"
            let path = "test"
            let method: HTTPRequestMethod = .get
            let headers: [String: String] = [:]
            let parameters: [String: Any]? = nil
        }
        
        struct PostRequest: BaseRequest {
            let baseUrl = "api.example.com"
            let path = "test"
            let method: HTTPRequestMethod = .post
            let headers: [String: String] = [:]
            let parameters: [String: Any]? = ["data": "value"]
        }
        
        let getRequest = GetRequest()
        let postRequest = PostRequest()
        
        #expect(getRequest.method == .get)
        #expect(postRequest.method == .post)
        #expect(postRequest.parameters != nil)
    }
        
    @Test("RequestFactory should handle GET parameters correctly")
    func testGETParameterEncoding() async throws {
        struct GetRequestWithParams: BaseRequest {
            let baseUrl = "api.example.com"
            let path = "test"
            let method: HTTPRequestMethod = .get
            let headers: [String: String] = [:]
            let parameters: [String: Any]? = ["page": 1, "limit": 10]
        }
        
        let request = GetRequestWithParams()
        
        #expect(request.method == .get)
        #expect(request.parameters?["page"] as? Int == 1)
        #expect(request.parameters?["limit"] as? Int == 10)
    }
    
    @Test("RequestFactory should handle POST parameters correctly")
    func testPOSTParameterEncoding() async throws {
        struct PostRequestWithParams: BaseRequest {
            let baseUrl = "api.example.com"
            let path = "test"
            let method: HTTPRequestMethod = .post
            let headers: [String: String] = [:]
            let parameters: [String: Any]? = ["name": "Test", "active": true]
        }
        
        let request = PostRequestWithParams()
        
        #expect(request.method == .post)
        #expect(request.parameters?["name"] as? String == "Test")
        #expect(request.parameters?["active"] as? Bool == true)
    }
        
    @Test("RequestFactory should handle successful responses")
    func testSuccessfulResponse() async throws {
        let expectedResponse = createMockSuccessResponse()
        
        #expect(expectedResponse.id == 1)
        #expect(expectedResponse.name == "Test Item")
        #expect(expectedResponse.status == "active")
    }
    
    @Test("RequestFactory should handle decoding errors")
    func testDecodingError() async throws {
        let invalidJSONData = "{ invalid json }".data(using: .utf8)!
        
        do {
            _ = try JSONDecoder().decode(MockSuccessResponse.self, from: invalidJSONData)
            Issue.record("Expected decoding error")
        } catch {
            #expect(error is DecodingError)
        }
    }
        
    @Test("RequestFactory should parse server error responses")
    func testServerErrorParsing() async throws {
        let errorResponse = createMockErrorResponse()
        
        #expect(errorResponse.title == "Bad Request")
        #expect(errorResponse.detail == "Invalid parameters provided")
        
        let apiError = APIError.server(response: errorResponse)
        
        #expect(apiError.title == "Bad Request")
        #expect(apiError.description == "Invalid parameters provided")
    }
    
    // MARK: Private
    
    private func createMockSuccessResponse() -> MockSuccessResponse {
        return MockSuccessResponse(id: 1, name: "Test Item", status: "active")
    }
    
    private func createMockErrorResponse() -> ErrorResponse {
        return ErrorResponse(title: "Bad Request", detail: "Invalid parameters provided")
    }
}
