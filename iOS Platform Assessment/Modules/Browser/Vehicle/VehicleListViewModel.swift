//
//  VehicleListViewModel.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - VehicleListViewModelProviding

protocol VehicleListViewModelProviding: ObservableObject {
    var selectedVehicle: Vehicle? { get set }
    var loadingState: LoadingState<[Vehicle], APIError> { get }
    var searchText: String { get set }
    var lastUpdated: Date? { get }
    var vehicleFuelEntries: [Int: [FuelEntry]] { get }
    
    func loadVehicles() async
    func filteredVehicles(from vehicles: [Vehicle]) -> [Vehicle]
}

// MARK: - VehicleListViewModel

final class VehicleListViewModel: VehicleListViewModelProviding {
    
    // MARK: Lifecycle
    
    init(vehicleService: VehicleServiceProviding = VehicleService()) {
        self.vehicleService = vehicleService
    }
    
    // MARK: Internal
    
    @Published private(set) var loadingState: LoadingState<[Vehicle], APIError> = .loading
    @Published private(set) var vehicleFuelEntries: [Int: [FuelEntry]] = [:]
    
    @Published var selectedVehicle: Vehicle? = nil
    @Published var searchText: String = ""
    @Published var lastUpdated: Date?
    
    func loadVehicles() async {
        do {
            let vehicles = try await vehicleService.fetchVehicles(query: .init(startCursor: nil, perPage: 5))
            
            await MainActor.run {
                loadingState = .loaded(vehicles.records)
                lastUpdated = Date()
                vehicleFuelEntries = mapFuelEntries(to: vehicles.records)
            }
        } catch {
            await MainActor.run {
                if let apiError = error as? APIError {
                    loadingState = .error(apiError)
                } else {
                    loadingState = .error(.unknown)
                }
            }
        }
    }
    
    func filteredVehicles(from vehicles: [Vehicle]) -> [Vehicle] {
        if searchText.isEmpty {
            return vehicles
        } else {
            let searchTerms = searchText.lowercased().split(separator: " ")
            return vehicles.filter { vehicle in
                searchTerms.allSatisfy { term in
                    vehicle.customName?.lowercased().contains(term) ?? false ||
                    vehicle.make.lowercased().contains(term) ||
                    vehicle.model.lowercased().contains(term) ||
                    "\(vehicle.year)".lowercased().contains(term) ||
                    ((vehicle.location?.lowercased().contains(term)) != nil) ||
                    ((vehicle.vehicleStatusName?.lowercased().contains(term)) != nil)
                }
            }
        }
    }
        
    // MARK: Private
    
    private var vehicleService: VehicleServiceProviding
    
    private func mapFuelEntries(to vehicles: [Vehicle]) -> [Int: [FuelEntry]] {
        var vehicleFuelEntries: [Int: [FuelEntry]] = [:]
        
        // Initialize empty arrays for each vehicle
        for vehicle in vehicles {
            vehicleFuelEntries[vehicle.id] = []
        }
        
        // Map fuel entries to their corresponding vehicles
        for fuelEntry in SampleData.fuelEntries {
            if let vehicleId = fuelEntry.vehicleId {
                vehicleFuelEntries[vehicleId]?.append(fuelEntry)
            }
        }
        
        return vehicleFuelEntries
    }
}
