//
//  MockVehicleService.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

@testable import iOS_Platform_Assessment

// MARK: - MockVehicleService

final class MockVehicleService: VehicleServiceProviding {
    
    // MARK: Internal
    
    var shouldThrowError = false
    var mockVehicleData: VehicleListData?
    var mockError: APIError?
    var fetchCallCount = 0
    var lastQuery: VehicleListQuery?
    
    func fetchVehicles(query: VehicleListQuery) async throws -> VehicleListData {
        lastQuery = query
        fetchCallCount += 1
        
        if shouldThrowError {
            throw mockError ?? APIError.unknown
        }
        
        guard let data = mockVehicleData else {
            throw APIError.unknown
        }
        
        return data
    }
    
    func reset() {
        shouldThrowError = false
        mockVehicleData = nil
        mockError = nil
        fetchCallCount = 0
        lastQuery = nil
    }
}
