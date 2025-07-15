//
//  VehicleService.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - VehicleServiceProviding

protocol VehicleServiceProviding {
    func fetchVehicles() async throws -> [Vehicle]
}

// MARK: - VehicleService

final class VehicleService: VehicleServiceProviding {
    
    // MARK: Lifecycle
    
    init(requestFactory: RequestFactoryProviding = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
    // MARK: Internal
    
    func fetchVehicles() async throws -> [Vehicle] {
        SampleData.vehicleList
//        try await requestFactory.request(with: VehicleApiRouter.vehicleList)
    }
    
    // MARK: Private
    
    private var requestFactory: RequestFactoryProviding
}
