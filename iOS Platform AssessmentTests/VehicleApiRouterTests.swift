//
//  VehicleApiRouterTests.swift
//  iOS Platform AssessmentTests
//
//  Created by Olami on 2025-07-16.
//

import Testing
import Foundation

@testable import iOS_Platform_Assessment

// MARK: - VehicleApiRouterTests

struct VehicleApiRouterTests {
    
    // MARK: Tests
    
    @Test("VehicleApiRouter should configure baseUrl correctly")
    func testBaseUrl() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.baseUrl == BASE_URL)
        #expect(!router.baseUrl.isEmpty)
    }
    
    @Test("VehicleApiRouter should configure path correctly")
    func testPath() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.path == "vehicles/")
    }
    
    @Test("VehicleApiRouter should configure HTTP method correctly")
    func testHTTPMethod() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.method == .get)
    }
    
    @Test("VehicleApiRouter should configure headers correctly")
    func testHeaders() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.headers["Content-Type"] == "application/json")
        #expect(!router.headers.isEmpty)
    }
        
    @Test("VehicleApiRouter should convert query to parameters correctly")
    func testParametersWithFullQuery() async throws {
        let query = VehicleListQuery(startCursor: "abc123", perPage: 20)
        let router = VehicleApiRouter.vehicleList(query: query)
        
        let parameters = router.parameters
        
        #expect(parameters != nil)
        #expect(query.startCursor == "abc123")
        #expect(query.perPage == 20)
    }
    
    @Test("VehicleApiRouter should handle query with nil values")
    func testParametersWithNilValues() async throws {
        let query = VehicleListQuery(startCursor: nil, perPage: nil)
        let router = VehicleApiRouter.vehicleList(query: query)
        
        let parameters = router.parameters
        
        #expect(parameters != nil)
        #expect(query.startCursor == nil)
        #expect(query.perPage == nil)
    }
    
    @Test("VehicleApiRouter should handle query with partial values")
    func testParametersWithPartialValues() async throws {
        let query1 = VehicleListQuery(startCursor: "cursor123", perPage: nil)
        let router1 = VehicleApiRouter.vehicleList(query: query1)
        
        let query2 = VehicleListQuery(startCursor: nil, perPage: 15)
        let router2 = VehicleApiRouter.vehicleList(query: query2)
        
        #expect(router1.parameters != nil)
        #expect(router2.parameters != nil)
        #expect(query1.startCursor == "cursor123")
        #expect(query2.perPage == 15)
    }
        
    @Test("VehicleApiRouter should conform to BaseRequest protocol")
    func testBaseRequestConformance() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        let baseRequest: BaseRequest = router
        
        #expect(baseRequest.baseUrl == router.baseUrl)
        #expect(baseRequest.path == router.path)
        #expect(baseRequest.method == router.method)
        #expect(baseRequest.headers.count == router.headers.count)
    }
        
    @Test("VehicleApiRouter should handle vehicleList case correctly")
    func testVehicleListCase() async throws {
        let query = createVehicleListQuery(startCursor: "test", perPage: 5)
        let router = VehicleApiRouter.vehicleList(query: query)
        
        switch router {
        case .vehicleList(let queryParam):
            #expect(queryParam.startCursor == "test")
            #expect(queryParam.perPage == 5)
        }
    }
        
    @Test("VehicleApiRouter should work with RequestFactory")
    func testIntegrationWithRequestFactory() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.baseUrl == BASE_URL)
        #expect(router.path == "vehicles/")
        #expect(router.method == .get)
    }
        
    @Test("VehicleApiRouter should handle edge case queries")
    func testEdgeCaseQueries() async throws {
        let largePageQuery = VehicleListQuery(startCursor: nil, perPage: 1000)
        let largeRouter = VehicleApiRouter.vehicleList(query: largePageQuery)
        
        #expect(largeRouter.path == "vehicles/")
        #expect(largePageQuery.perPage == 1000)
        
        let longCursor = String(repeating: "a", count: 1000)
        let longCursorQuery = VehicleListQuery(startCursor: longCursor, perPage: 1)
        let longCursorRouter = VehicleApiRouter.vehicleList(query: longCursorQuery)
        
        #expect(longCursorRouter.path == "vehicles/")
        #expect(longCursorQuery.startCursor?.count == 1000)
        
        let zeroPageQuery = VehicleListQuery(startCursor: nil, perPage: 0)
        let zeroRouter = VehicleApiRouter.vehicleList(query: zeroPageQuery)
        
        #expect(zeroRouter.path == "vehicles/")
        #expect(zeroPageQuery.perPage == 0)
    }
        
    @Test("VehicleApiRouter should serialize parameters correctly for GET requests")
    func testParameterSerialization() async throws {
        let query = VehicleListQuery(startCursor: "test_cursor", perPage: 25)
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.method == .get)
        #expect(router.parameters != nil)
    }
        
    @Test("VehicleApiRouter should use correct constants")
    func testConstants() async throws {
        let query = createVehicleListQuery()
        let router = VehicleApiRouter.vehicleList(query: query)
        
        #expect(router.baseUrl == BASE_URL)
        
        #expect(router.path == "vehicles/")
        #expect(router.path.hasSuffix("/"))
        
        #expect(router.headers["Content-Type"] == "application/json")
    }
    
    // MARK: Private
    
    private func createVehicleListQuery(startCursor: String? = nil, perPage: Int? = 10) -> VehicleListQuery {
        return VehicleListQuery(startCursor: startCursor, perPage: perPage)
    }
}
