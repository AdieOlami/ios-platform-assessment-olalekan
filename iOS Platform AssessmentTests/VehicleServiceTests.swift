//
//  VehicleServiceTests.swift
//  iOS Platform AssessmentTests
//
//  Created by Olami on 2025-07-16.
//

import Foundation
import Testing

@testable import iOS_Platform_Assessment

// MARK: - VehicleServiceTests

struct VehicleServiceTests {
    
    // MARK: Tests
    
    @Test("VehicleService should fetch vehicles successfully")
    func testFetchVehiclesSuccess() async throws {
        let mockRequestFactory = MockRequestFactory()
        let service = VehicleService(requestFactory: mockRequestFactory)
        let expectedData = createMockVehicleData()
        
        mockRequestFactory.mockResponse = expectedData
        
        let query = VehicleListQuery(startCursor: nil, perPage: 10)
        let result = try await service.fetchVehicles(query: query)
        
        #expect(mockRequestFactory.requestCallCount == 1)
        #expect(result.records.count == 3)
        #expect(result.startCursor == "0")
        #expect(result.nextCursor == "3")
        #expect(result.perPage == 10)
        #expect(result.estimatedRemainingCount == 5)
        #expect(result.records.first?.id == 1)
        #expect(result.records.first?.name == "Vehicle 1")
    }
    
    @Test("VehicleService should handle API errors")
    func testFetchVehiclesError() async throws {
        let mockRequestFactory = MockRequestFactory()
        let service = VehicleService(requestFactory: mockRequestFactory)
        
        mockRequestFactory.shouldThrowError = true
        mockRequestFactory.mockError = APIError.httpError(500)
        
        let query = VehicleListQuery(startCursor: nil, perPage: 10)
        
        do {
            _ = try await service.fetchVehicles(query: query)
            Issue.record("Expected error to be thrown")
        } catch let error as APIError {
            #expect(error == APIError.httpError(500))
            #expect(mockRequestFactory.requestCallCount == 1)
        }
    }
    
    @Test("VehicleService should handle decoding errors")
    func testFetchVehiclesDecodingError() async throws {
        let mockRequestFactory = MockRequestFactory()
        let service = VehicleService(requestFactory: mockRequestFactory)
        
        mockRequestFactory.mockResponse = "Invalid response type"
        
        let query = VehicleListQuery(startCursor: nil, perPage: 10)
        
        do {
            _ = try await service.fetchVehicles(query: query)
            Issue.record("Expected decoding error to be thrown")
        } catch let error as APIError {
            if case .decodingError = error {
                // Expected decoding error
                #expect(mockRequestFactory.requestCallCount == 1)
            } else {
                Issue.record("Expected decoding error but got: \(error)")
            }
        }
    }
    
    @Test("VehicleService should pass correct parameters to request factory")
    func testCorrectParametersPassed() async throws {
        let mockRequestFactory = MockRequestFactory()
        let service = VehicleService(requestFactory: mockRequestFactory)
        let expectedData = createMockVehicleData()
        
        mockRequestFactory.mockResponse = expectedData
        
        let query = VehicleListQuery(startCursor: "10", perPage: 20)
        _ = try await service.fetchVehicles(query: query)
        
        #expect(mockRequestFactory.requestCallCount == 1)
        #expect(mockRequestFactory.lastRequestBuilder != nil)
        
        #expect(mockRequestFactory.lastCachePolicy != nil)
    }
    
    @Test("VehicleService should handle empty response")
    func testFetchVehiclesEmptyResponse() async throws {
        let mockRequestFactory = MockRequestFactory()
        let service = VehicleService(requestFactory: mockRequestFactory)
        
        let emptyData = VehicleListData(
            startCursor: "0",
            nextCursor: nil,
            perPage: 10,
            estimatedRemainingCount: 0,
            records: []
        )
        
        mockRequestFactory.mockResponse = emptyData
        
        let query = VehicleListQuery(startCursor: nil, perPage: 10)
        let result = try await service.fetchVehicles(query: query)
        
        #expect(result.records.isEmpty)
        #expect(result.nextCursor == nil)
        #expect(result.estimatedRemainingCount == 0)
    }
    
    @Test("VehicleService should handle pagination correctly")
    func testFetchVehiclesPagination() async throws {
        let mockRequestFactory = MockRequestFactory()
        let service = VehicleService(requestFactory: mockRequestFactory)
        
        let paginatedData = VehicleListData(
            startCursor: "10",
            nextCursor: "20",
            perPage: 10,
            estimatedRemainingCount: 15,
            records: createMockVehicleData().records
        )
        
        mockRequestFactory.mockResponse = paginatedData
        
        let query = VehicleListQuery(startCursor: "10", perPage: 10)
        let result = try await service.fetchVehicles(query: query)
        
        #expect(result.startCursor == "10")
        #expect(result.nextCursor == "20")
        #expect(result.estimatedRemainingCount == 15)
        #expect(result.records.count == 3)
    }
    
    // MARK: Private
    
    private func createMockVehicleData() -> VehicleListData {
        let vehicles = [
            Vehicle(id: 1, name: "Vehicle 1", model: "Model X", year: 2022, make: "Tesla", vehicleStatusName: "Active", location: "SF", customName: "Tesla 1"),
            Vehicle(id: 2, name: "Vehicle 2", model: "Prius", year: 2021, make: "Toyota", vehicleStatusName: "Active", location: "LA", customName: "Toyota 1"),
            Vehicle(id: 3, name: "Vehicle 3", model: "Accord", year: 2020, make: "Honda", vehicleStatusName: "Inactive", location: "NY", customName: "Honda 1")
        ]
        
        return VehicleListData(
            startCursor: "0",
            nextCursor: "3",
            perPage: 10,
            estimatedRemainingCount: 5,
            records: vehicles
        )
    }
}
