//
//  VehicleService.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - VehicleServiceProviding

protocol VehicleServiceProviding {
    func fetchVehicles(query: VehicleListQuery) async throws -> VehicleListData
}

// MARK: - VehicleService

final class VehicleService: VehicleServiceProviding {
    
    // MARK: Lifecycle
    
    init(requestFactory: RequestFactoryProviding = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
    // MARK: Internal
    
    func fetchVehicles(query: VehicleListQuery) async throws -> VehicleListData {
        // Use SampleData for UI tests to maintain test compatibility
        if ProcessInfo.processInfo.environment["IS_UI_TESTING"] == "1" {
            let startIndex = 0
            let endIndex = min(startIndex + (query.perPage ?? 10), SampleData.vehicleList.count)
            let vehiclesSubset = Array(SampleData.vehicleList[startIndex..<endIndex])
            
            return VehicleListData(
                startCursor: "0",
                nextCursor: endIndex < SampleData.vehicleList.count ? "\(endIndex)" : nil,
                perPage: query.perPage ?? 10,
                estimatedRemainingCount: max(0, SampleData.vehicleList.count - endIndex),
                records: vehiclesSubset
            )
        }
        
        // Use API for production
        return try await requestFactory.request(with: VehicleApiRouter.vehicleList(query: query))
    }
    
    // MARK: Private
    
    private var requestFactory: RequestFactoryProviding
}
