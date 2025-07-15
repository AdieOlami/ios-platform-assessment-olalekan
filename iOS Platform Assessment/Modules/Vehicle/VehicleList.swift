import Foundation
import SwiftUI

struct VehicleList: View {
    @State private var isLoading = true
    @State private var searchText = ""
    @State private var selectedVehicle: Vehicle?
    @State private var lastUpdated = Date()
    var vehicleFuelEntries: [Int: [FuelEntry]] = [:]
    
    init(isLoading: Bool = true, searchText: String = "", selectedVehicle: Vehicle? = nil, lastUpdated: Date = Date()) {
        self.isLoading = isLoading
        self.searchText = searchText
        self.selectedVehicle = selectedVehicle
        self.lastUpdated = lastUpdated
        self.vehicleFuelEntries = mapFuelEntriesToVehicles()
    }
    
    private func mapFuelEntriesToVehicles() -> [Int: [FuelEntry]] {
        var vehicleFuelEntries: [Int: [FuelEntry]] = [:]
        
        // Initialize empty arrays for each vehicle
        for vehicle in SampleData.vehicleList {
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
    
    var filteredVehicles: [Vehicle] {
        
        if searchText.isEmpty {
            return SampleData.vehicleList
        } else {
            let searchTerms = searchText.lowercased().split(separator: " ")
            return SampleData.vehicleList.filter { vehicle in
                searchTerms.allSatisfy { term in
                    vehicle.customName.lowercased().contains(term) ||
                    vehicle.make.lowercased().contains(term) ||
                    vehicle.model.lowercased().contains(term) ||
                    vehicle.year.lowercased().contains(term)
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                            lastUpdated = Date()
                        }
                    }
            } else {
                VStack {
                    SearchBar(text: $searchText)
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .onChange(of: searchText) { _ in
                            lastUpdated = Date()
                        }
                    
                    List {
                        ForEach(filteredVehicles, id: \.id) { vehicle in
                            NavigationLink(destination: VehicleView(vehicle: vehicle)) {
                                VehicleRow(vehicle: vehicle)
                                    .onAppear {
                                        selectedVehicle = vehicle
                                    }
                            }
                            .accessibilityIdentifier(AccessibilityIdentifiers.VehicleList.vehicleListItem(id: vehicle.id))
                            .background(selectedVehicle?.id == vehicle.id ? Color.gray.opacity(0.1) : Color.clear)
                        }
                    }
                    .navigationTitle("Vehicles")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

struct VehicleRow: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack {
            Image(systemName: "car")
                .imageScale(.large)
                .foregroundColor(.gray)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(vehicle.customName)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text(vehicle.year)
                    Text(vehicle.make)
                    Text(vehicle.model)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(vehicle.status == "Active" ? .green : .red)
                    Text(vehicle.status)
                    Text("\u{2022}")
                    Text(vehicle.location)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        VehicleList()
    }
}
