import Foundation
import Testing

@testable import iOS_Platform_Assessment

// MARK: - iOS_Platform_AssessmentTests

struct iOS_Platform_AssessmentTests {

    // MARK: Tests
    
    @Test("App should have correct bundle identifier")
    func testBundleIdentifier() async throws {
        let bundleId = Bundle.main.bundleIdentifier
        #expect(bundleId != nil)
        #expect(bundleId?.contains("iOS") == true || bundleId?.contains("Assessment") == true)
    }
    
    @Test("Sample data should be available")
    func testSampleDataAvailability() async throws {
        #expect(!SampleData.vehicleList.isEmpty)
        #expect(!SampleData.fuelEntries.isEmpty)
        
        let firstVehicle = SampleData.vehicleList.first!
        #expect(firstVehicle.id > 0)
        #expect(!firstVehicle.name.isEmpty)
        #expect(!firstVehicle.make.isEmpty)
        #expect(!firstVehicle.model.isEmpty)
        #expect(firstVehicle.year > 1900)
        
        let firstFuelEntry = SampleData.fuelEntries.first!
        #expect(firstFuelEntry.id ?? 0 > 0)
        #expect(firstFuelEntry.vehicleId != nil)
        #expect(firstFuelEntry.odometer ?? 0 > 0)
        #expect(firstFuelEntry.gallons ?? 0 > 0)
    }
    
    @Test("Vehicle model should be Codable")
    func testVehicleModelCodable() async throws {
        let vehicle = Vehicle(
            id: 1,
            name: "Test Vehicle",
            model: "Test Model",
            year: 2023,
            make: "Test Make",
            vehicleStatusName: "Active",
            location: "Test Location",
            customName: "Custom Test"
        )
        
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(vehicle)
        #expect(!encodedData.isEmpty)
        
        let decoder = JSONDecoder()
        let decodedVehicle = try decoder.decode(Vehicle.self, from: encodedData)
        
        #expect(decodedVehicle.id == vehicle.id)
        #expect(decodedVehicle.name == vehicle.name)
        #expect(decodedVehicle.model == vehicle.model)
        #expect(decodedVehicle.year == vehicle.year)
        #expect(decodedVehicle.make == vehicle.make)
        #expect(decodedVehicle.vehicleStatusName == vehicle.vehicleStatusName)
        #expect(decodedVehicle.location == vehicle.location)
        #expect(decodedVehicle.customName == vehicle.customName)
    }
    
    @Test("VehicleListData model should be Codable")
    func testVehicleListDataCodable() async throws {
        let vehicleListData = VehicleListData(
            startCursor: "0",
            nextCursor: "10",
            perPage: 10,
            estimatedRemainingCount: 5,
            records: [
                Vehicle(id: 1, name: "Test", model: "Model", year: 2023, make: "Make", vehicleStatusName: nil, location: nil, customName: nil)
            ]
        )
        
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(vehicleListData)
        #expect(!encodedData.isEmpty)
        
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(VehicleListData.self, from: encodedData)
        
        #expect(decodedData.startCursor == vehicleListData.startCursor)
        #expect(decodedData.nextCursor == vehicleListData.nextCursor)
        #expect(decodedData.perPage == vehicleListData.perPage)
        #expect(decodedData.estimatedRemainingCount == vehicleListData.estimatedRemainingCount)
        #expect(decodedData.records.count == vehicleListData.records.count)
    }
    
    @Test("VehicleListQuery model should be Codable")
    func testVehicleListQueryCodable() async throws {
        let query = VehicleListQuery(startCursor: "test", perPage: 20)
        
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(query)
        #expect(!encodedData.isEmpty)
        
        let decoder = JSONDecoder()
        let decodedQuery = try decoder.decode(VehicleListQuery.self, from: encodedData)
        
        #expect(decodedQuery.startCursor == query.startCursor)
        #expect(decodedQuery.perPage == query.perPage)
    }
    
    @Test("API Error should provide correct descriptions")
    func testAPIErrorDescriptions() async throws {
        let errorResponse = ErrorResponse(title: "Test Error", detail: "Test error detail")
        let serverError = APIError.server(response: errorResponse)
        
        #expect(serverError.title == "Test Error")
        #expect(serverError.description == "Test error detail")
        
        let httpError = APIError.httpError(404)
        #expect(httpError.title == "")
        #expect(httpError.description == "")
        
        let unknownError = APIError.unknown
        #expect(unknownError.title == "")
        #expect(unknownError.description == "")
    }
    
    @Test("Loading state should handle all cases correctly")
    func testLoadingState() async throws {
        let loadingState: LoadingState<[Vehicle], APIError> = .loading
        let loadedState: LoadingState<[Vehicle], APIError> = .loaded([])
        let errorState: LoadingState<[Vehicle], APIError> = .error(.unknown)
        
        switch loadingState {
        case .loading:
            #expect(true)
        default:
            Issue.record("Expected loading state")
        }
        
        switch loadedState {
        case .loaded(let vehicles):
            #expect(vehicles.isEmpty)
        default:
            Issue.record("Expected loaded state")
        }
        
        switch errorState {
        case .error(let error):
            #expect(error == .unknown)
        default:
            Issue.record("Expected error state")
        }
    }

}
