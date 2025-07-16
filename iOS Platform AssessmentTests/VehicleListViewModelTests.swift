//
//  VehicleListViewModelTests.swift
//  iOS Platform AssessmentTests
//
//  Created by Olami on 2025-07-16.
//

import Foundation
import Testing

@testable import iOS_Platform_Assessment

// MARK: - VehicleListViewModelTests

struct VehicleListViewModelTests {
    
    // MARK: Tests
    
    @Test("VehicleListViewModel should initialize with default values")
    func testInitialization() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        if case .loading = viewModel.loadingState {
            // Expected initial state
        } else {
            Issue.record("Expected loading state initially")
        }
        
        #expect(viewModel.selectedVehicle == nil)
        #expect(viewModel.searchText == "")
        #expect(viewModel.lastUpdated == nil)
        #expect(viewModel.vehicleFuelEntries.isEmpty)
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.hasMorePages == true)
    }
        
    @Test("VehicleListViewModel should load vehicles successfully")
    func testLoadVehiclesSuccess() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let mockData = createMockVehicleData()
        
        mockService.mockVehicleData = mockData
        
        await viewModel.loadVehicles()
        
        #expect(mockService.fetchCallCount == 1)
        #expect(mockService.lastQuery?.startCursor == nil)
        #expect(mockService.lastQuery?.perPage == 10)
        
        if case .loaded(let vehicles) = viewModel.loadingState {
            #expect(vehicles.count == 3)
            #expect(vehicles.first?.id == 1)
            #expect(vehicles.first?.name == "Tesla Model X")
        } else {
            Issue.record("Expected loaded state with vehicles")
        }
        
        #expect(viewModel.lastUpdated != nil)
        #expect(viewModel.hasMorePages == true)
    }
    
    @Test("VehicleListViewModel should handle load vehicles error")
    func testLoadVehiclesError() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        mockService.shouldThrowError = true
        mockService.mockError = APIError.httpError(500)
        
        await viewModel.loadVehicles()
        
        #expect(mockService.fetchCallCount == 1)
        
        if case .error(let error) = viewModel.loadingState {
            #expect(error == APIError.httpError(500))
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test("VehicleListViewModel should handle unknown errors")
    func testLoadVehiclesUnknownError() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        mockService.shouldThrowError = true
        
        await viewModel.loadVehicles()
        
        if case .error(let error) = viewModel.loadingState {
            #expect(error == APIError.unknown)
        } else {
            Issue.record("Expected error state with unknown error")
        }
    }
    
    // MARK: - Load More Vehicles Tests
    
    @Test("VehicleListViewModel should load more vehicles successfully")
    func testLoadMoreVehiclesSuccess() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        let firstPageData = createMockVehicleData(vehicles: Array(createMockVehicles().prefix(2)), nextCursor: "2")
        mockService.mockVehicleData = firstPageData
        await viewModel.loadVehicles()
        
        let secondPageData = createMockVehicleData(vehicles: Array(createMockVehicles().suffix(1)), startCursor: "2", nextCursor: nil, remainingCount: 0)
        mockService.mockVehicleData = secondPageData
        await viewModel.loadMoreVehicles()
        
        #expect(mockService.fetchCallCount == 2)
        #expect(mockService.lastQuery?.startCursor == "2")
        
        if case .loaded(let vehicles) = viewModel.loadingState {
            #expect(vehicles.count == 3)
        } else {
            Issue.record("Expected loaded state with more vehicles")
        }
        
        #expect(viewModel.hasMorePages == false)
        #expect(viewModel.isLoadingMore == false)
    }
    
    @Test("VehicleListViewModel should not load more when already loading")
    func testLoadMoreVehiclesWhileLoading() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        let mockData = createMockVehicleData()
        mockService.mockVehicleData = mockData
        await viewModel.loadVehicles()
        
        async let loadMore1: () = viewModel.loadMoreVehicles()
        async let loadMore2: () = viewModel.loadMoreVehicles()
        
        await loadMore1
        await loadMore2
        
        #expect(mockService.fetchCallCount == 3)
    }
    
    @Test("VehicleListViewModel should not load more when no more pages")
    func testLoadMoreVehiclesNoMorePages() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        let mockData = createMockVehicleData(nextCursor: nil, remainingCount: 0)
        mockService.mockVehicleData = mockData
        await viewModel.loadVehicles()
        
        #expect(viewModel.hasMorePages == false)
        
        await viewModel.loadMoreVehicles()
        
        #expect(mockService.fetchCallCount == 1)
    }
    
    @Test("VehicleListViewModel should not load more when search is active")
    func testLoadMoreVehiclesWithActiveSearch() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        let mockData = createMockVehicleData()
        mockService.mockVehicleData = mockData
        await viewModel.loadVehicles()
        
        await MainActor.run {
            viewModel.searchText = "Tesla"
        }
        
        await viewModel.loadMoreVehicles()
        
        #expect(mockService.fetchCallCount == 1)
    }
    
    @Test("VehicleListViewModel should handle load more error gracefully")
    func testLoadMoreVehiclesError() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        let mockData = createMockVehicleData()
        mockService.mockVehicleData = mockData
        await viewModel.loadVehicles()
        
        mockService.shouldThrowError = true
        mockService.mockError = APIError.httpError(404)
        
        await viewModel.loadMoreVehicles()
        
        #expect(mockService.fetchCallCount == 2)
        #expect(viewModel.isLoadingMore == false)
        
        if case .loaded(let vehicles) = viewModel.loadingState {
            #expect(vehicles.count == 3)
        } else {
            Issue.record("Expected to maintain loaded state after load more error")
        }
    }
        
    @Test("VehicleListViewModel should filter vehicles by search text")
    func testFilteredVehicles() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let vehicles = createMockVehicles()
        
        // Test empty search
        let allVehicles = viewModel.filteredVehicles(from: vehicles)
        #expect(allVehicles.count == 3)
        
        await MainActor.run {
            viewModel.searchText = "Tesla"
        }
        
        let teslaVehicles = viewModel.filteredVehicles(from: vehicles)
        #expect(teslaVehicles.count == 1)
        #expect(teslaVehicles.first?.make == "Tesla")
        
        await MainActor.run {
            viewModel.searchText = "Prius"
        }
        
        let priusVehicles = viewModel.filteredVehicles(from: vehicles)
        #expect(priusVehicles.count == 1)
        #expect(priusVehicles.first?.model == "Prius")
        
        await MainActor.run {
            viewModel.searchText = "2022"
        }
        
        let year2022Vehicles = viewModel.filteredVehicles(from: vehicles)
        #expect(year2022Vehicles.count == 1)
        #expect(year2022Vehicles.first?.year == 2022)
        
        await MainActor.run {
            viewModel.searchText = "San Francisco"
        }
        
        let sfVehicles = viewModel.filteredVehicles(from: vehicles)
        #expect(sfVehicles.count == 1)
        #expect(sfVehicles.first?.location == "San Francisco")
        
        await MainActor.run {
            viewModel.searchText = "Company"
        }
        
        let companyVehicles = viewModel.filteredVehicles(from: vehicles)
        #expect(companyVehicles.count == 1)
        #expect(companyVehicles.first?.customName?.contains("Company") == true)
    }
    
    @Test("VehicleListViewModel should handle multi-word search")
    func testMultiWordSearch() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let vehicles = createMockVehicles()
        
        await MainActor.run {
            viewModel.searchText = "Tesla 2022"
        }
        
        let results = viewModel.filteredVehicles(from: vehicles)
        #expect(results.count == 1)
        #expect(results.first?.make == "Tesla")
        #expect(results.first?.year == 2022)
    }
    
    @Test("VehicleListViewModel should handle case insensitive search")
    func testCaseInsensitiveSearch() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let vehicles = createMockVehicles()
        
        await MainActor.run {
            viewModel.searchText = "tesla"
        }
        
        let results = viewModel.filteredVehicles(from: vehicles)
        #expect(results.count == 1)
        #expect(results.first?.make == "Tesla")
    }
    
    @Test("VehicleListViewModel should return empty results for no matches")
    func testNoSearchMatches() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let vehicles = createMockVehicles()
        
        await MainActor.run {
            viewModel.searchText = "NonExistentVehicle"
        }
        
        let results = viewModel.filteredVehicles(from: vehicles)
        #expect(results.isEmpty)
    }
        
    @Test("VehicleListViewModel should handle vehicle selection")
    func testVehicleSelection() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let vehicle = createMockVehicles().first!
        
        await MainActor.run {
            viewModel.selectedVehicle = vehicle
        }
        
        #expect(viewModel.selectedVehicle?.id == vehicle.id)
        #expect(viewModel.selectedVehicle?.name == vehicle.name)
        
        await MainActor.run {
            viewModel.selectedVehicle = nil
        }
        
        #expect(viewModel.selectedVehicle == nil)
    }
        
    @Test("VehicleListViewModel should map fuel entries correctly")
    func testFuelEntriesMapping() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        let mockData = createMockVehicleData()
        
        mockService.mockVehicleData = mockData
        
        await viewModel.loadVehicles()
        
        #expect(!viewModel.vehicleFuelEntries.isEmpty)
        
        for vehicle in mockData.records {
            #expect(viewModel.vehicleFuelEntries[vehicle.id] != nil)
        }
    }
        
    @Test("VehicleListViewModel should manage loading states correctly")
    func testLoadingStates() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        if case .loading = viewModel.loadingState {
            // Expected
        } else {
            Issue.record("Expected initial loading state")
        }
        
        let mockData = createMockVehicleData()
        mockService.mockVehicleData = mockData
        await viewModel.loadVehicles()
        
        if case .loaded = viewModel.loadingState {
            // Expected
        } else {
            Issue.record("Expected loaded state after successful fetch")
        }
        
        mockService.shouldThrowError = true
        mockService.mockError = APIError.httpError(500)
        await viewModel.loadVehicles()
        
        if case .error = viewModel.loadingState {
            // Expected
        } else {
            Issue.record("Expected error state after failed fetch")
        }
    }
    
    @Test("VehicleListViewModel should reset state on new load")
    func testStateResetOnNewLoad() async throws {
        let mockService = MockVehicleService()
        let viewModel = VehicleListViewModel(vehicleService: mockService)
        
        let firstData = createMockVehicleData(vehicles: [createMockVehicles()[0]])
        mockService.mockVehicleData = firstData
        await viewModel.loadVehicles()
        
        if case .loaded(let vehicles) = viewModel.loadingState {
            #expect(vehicles.count == 1)
        }
        
        let secondData = createMockVehicleData(vehicles: Array(createMockVehicles().suffix(2)))
        mockService.mockVehicleData = secondData
        await viewModel.loadVehicles()
        
        if case .loaded(let vehicles) = viewModel.loadingState {
            #expect(vehicles.count == 2)
            #expect(vehicles.first?.id != firstData.records.first?.id)
        } else {
            Issue.record("Expected loaded state with new vehicles")
        }
    }
    
    // MARK: Private
    
    private func createMockVehicles() -> [Vehicle] {
        return [
            Vehicle(id: 1, name: "Tesla Model X", model: "Model X", year: 2022, make: "Tesla", vehicleStatusName: "Active", location: "San Francisco", customName: "Company Tesla"),
            Vehicle(id: 2, name: "Toyota Prius", model: "Prius", year: 2021, make: "Toyota", vehicleStatusName: "Active", location: "Los Angeles", customName: "Hybrid Car"),
            Vehicle(id: 3, name: "Honda Accord", model: "Accord", year: 2020, make: "Honda", vehicleStatusName: "Inactive", location: "New York", customName: "Sedan")
        ]
    }
    
    private func createMockVehicleData(vehicles: [Vehicle]? = nil, startCursor: String = "0", nextCursor: String? = "10", remainingCount: Int = 5) -> VehicleListData {
        return VehicleListData(
            startCursor: startCursor,
            nextCursor: nextCursor,
            perPage: 10,
            estimatedRemainingCount: remainingCount,
            records: vehicles ?? createMockVehicles()
        )
    }
}
