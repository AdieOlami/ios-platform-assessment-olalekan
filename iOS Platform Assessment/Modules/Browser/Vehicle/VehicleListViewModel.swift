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
    var isLoadingMore: Bool { get }
    var hasMorePages: Bool { get }
    
    func loadVehicles() async
    func loadMoreVehicles() async
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
    @Published private(set) var isLoadingMore: Bool = false
    @Published private(set) var hasMorePages: Bool = true
    
    @Published var selectedVehicle: Vehicle? = nil
    @Published var searchText: String = ""
    @Published var lastUpdated: Date?
    
    func loadVehicles() async {
        await MainActor.run {
            loadingState = .loading
            allVehicles = []
            nextCursor = nil
            hasMorePages = true
        }
        
        do {
            let vehicleData = try await vehicleService.fetchVehicles(
                query: .init(
                    startCursor: nil,
                    perPage: pageSize))
            
            await MainActor.run {
                allVehicles = vehicleData.records
                nextCursor = vehicleData.nextCursor
                hasMorePages = nextCursor != nil && vehicleData.estimatedRemainingCount > 0
                loadingState = .loaded(allVehicles)
                lastUpdated = Date()
                vehicleFuelEntries = mapFuelEntries(to: allVehicles)
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
    
    func loadMoreVehicles() async {
        guard !isLoadingMore, hasMorePages, searchText.isEmpty, let cursor = nextCursor else { return }
        
        await MainActor.run {
            isLoadingMore = true
        }
        
        do {
            let vehicleData = try await vehicleService.fetchVehicles(
                query: .init(startCursor:
                                cursor,
                             perPage: pageSize))
            
            await MainActor.run {
                allVehicles.append(contentsOf: vehicleData.records)
                nextCursor = vehicleData.nextCursor
                hasMorePages = nextCursor != nil && vehicleData.estimatedRemainingCount > 0
                loadingState = .loaded(allVehicles)
                lastUpdated = Date()
                vehicleFuelEntries = mapFuelEntries(to: allVehicles)
                isLoadingMore = false
            }
        } catch {
            await MainActor.run {
                isLoadingMore = false
                print("Failed to load more vehicles: \(error)")
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
                    vehicle.customName?.lowercased().contains(term) == true ||
                    vehicle.make.lowercased().contains(term) ||
                    vehicle.model.lowercased().contains(term) ||
                    "\(vehicle.year)".lowercased().contains(term) ||
                    vehicle.location?.lowercased().contains(term) == true ||
                    vehicle.vehicleStatusName?.lowercased().contains(term) == true
                }
            }
        }
    }
        
    // MARK: Private
    
    private var vehicleService: VehicleServiceProviding
    
    private var allVehicles: [Vehicle] = []
    private var nextCursor: String? = nil
    private let pageSize: Int = 10
    
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
