import Foundation
import SwiftUI

// MARK: - VehicleList

struct VehicleList<ViewModel: VehicleListViewModelProviding>: View {
    
    // MARK: Lifecycle
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: Internal
    
    var body: some View {
        ZStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .loaded(let vehicles):
                VStack {
                    SearchBar(text: $viewModel.searchText)
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                    
                    List {
                        ForEach(viewModel.filteredVehicles(from: vehicles), id: \.id) { vehicle in
                            NavigationLink(destination: VehicleView(vehicle: vehicle)) {
                                VehicleRow(vehicle: vehicle)
                                    .onAppear {
                                        viewModel.selectedVehicle = vehicle
                                    }
                            }
                            .accessibilityIdentifier(AccessibilityIdentifiers.VehicleList.vehicleListItem(id: vehicle.id))
                            .background(viewModel.selectedVehicle?.id == vehicle.id ? Color.gray.opacity(0.1) : Color.clear)
                        }
                    }
                    
                }
            case .error(let e):
                ErrorView(error: e)
            }
        }
        .navigationTitle("Vehicles")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadVehicles()
        }
    }
    
    // MARK: Private
    
    @StateObject private var viewModel: ViewModel
    
}

// MARK: - VehicleRow

struct VehicleRow: View {
    
    // MARK: Internal
    
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

// MARK: - Preview

#Preview {
    NavigationView {
        VehicleList(viewModel: VehicleListViewModel())
    }
}
