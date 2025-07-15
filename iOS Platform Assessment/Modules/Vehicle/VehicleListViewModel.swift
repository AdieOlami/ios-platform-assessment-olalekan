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
    var loadingState: LoadingState<[Vehicle], LoadingStateError> { get }
    var searchText: String { get set }
    var lastUpdated: Date? { get }
    
    func loadVehicles() async
}

// MARK: - VehicleListViewModel

final class VehicleListViewModel: VehicleListViewModelProviding {
    
    // MARK: Lifecycle
    
    init(vehicleService: VehicleServiceProviding = VehicleService()) {
        self.vehicleService = vehicleService
    }
    
    // MARK: Internal
    
    @Published private(set) var loadingState: LoadingState<[Vehicle], LoadingStateError> = .loading
    @Published var selectedVehicle: Vehicle? = nil
    @Published var searchText: String = ""
    @Published var lastUpdated: Date?
    
    func loadVehicles() async {
        do {
            let vehicles = try await vehicleService.fetchVehicles()
            
            await MainActor.run {
                loadingState = .loaded(vehicles)
                lastUpdated = Date()
            }
        } catch {
            await MainActor.run {
                loadingState = .error(.unableToLoadData)
            }
        }
    }
    
    // MARK: Private
    
    private var vehicleService: VehicleServiceProviding
}


//// MARK: - VehicleListViewModelProviding
//
//protocol VehicleListViewModelProviding: ObservableObject {
//    var vehicles: [Vehicle] { get }
//}
//
//// MARK: - VehicleListViewModel
//
//final class VehicleListViewModel: VehicleListViewModelProviding {
//    
//    // MARK: Lifecycle
//    
//    init() {
//        
//    }
//    
//    // MARK: Internal
//    
//    // MARK: Private
//}
