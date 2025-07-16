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
                    .onAppear {
                        pageLoadTracker = PerformanceTracker.shared.startPageLoad(
                            pageName: "VehicleList",
                            source: "Browse"
                        )
                    }
            case .loaded(let vehicles):
                VStack {
                    SearchBar(text: $viewModel.searchText)
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .onChange(of: viewModel.searchText) { _, searchText in
                            // Track search response time
                            let searchStartTime = CFAbsoluteTimeGetCurrent()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                let duration = CFAbsoluteTimeGetCurrent() - searchStartTime
                                let filteredVehicles = viewModel.filteredVehicles(from: vehicles)
                                PerformanceTracker.shared.trackSearchResponse(
                                    query: searchText,
                                    resultCount: filteredVehicles.count,
                                    duration: duration
                                )
                            }
                        }
                    
                    List {
                        ForEach(viewModel.filteredVehicles(from: vehicles), id: \.id) { vehicle in
                            NavigationLink(destination: VehicleView(vehicle: vehicle)) {
                                VehicleRow(vehicle: vehicle)
                                    .onAppear {
                                        viewModel.selectedVehicle = vehicle
                                        
                                        if vehicle.id == viewModel.filteredVehicles(from: vehicles).last?.id {
                                            Task {
                                                await viewModel.loadMoreVehicles()
                                            }
                                        }
                                    }
                            }
                            .trackNavigation(destination: "VehicleView", source: "VehicleList")
                            .accessibilityIdentifier(AccessibilityIdentifiers.VehicleList.vehicleListItem(id: vehicle.id))
                            .background(viewModel.selectedVehicle?.id == vehicle.id ? Color.gray.opacity(0.1) : Color.clear)
                        }
                        
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(0.8)
                                Text("Loading more vehicles...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        
                        if viewModel.hasMorePages && !viewModel.isLoadingMore && viewModel.searchText.isEmpty {
                            Button(action: {
                                Task {
                                    await viewModel.loadMoreVehicles()
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Load More")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                            .trackTap(
                                buttonName: "LoadMoreVehicles",
                                additionalProperties: [
                                    "current_count": viewModel.filteredVehicles(from: vehicles).count])
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .refreshable {
                        await viewModel.loadVehicles()
                    }
                    .onAppear {
                        pageLoadTracker?.complete()
                        pageLoadTracker = nil
                    }
                    
                }
            case .error(let e):
                ErrorView(error: e)
            }
        }
        .navigationTitle("Vehicles")
        .navigationBarTitleDisplayMode(.inline)
        .trackViewAppearance(viewName: "VehicleList")
        .task {
            await viewModel.loadVehicles()
        }
    }
    
    // MARK: Private
    
    @StateObject private var viewModel: ViewModel
    @State private var pageLoadTracker: PageLoadTracker?
    
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
                Text(vehicle.customName ?? "John Doe")
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text("\(vehicle.year)")
                    Text(vehicle.make)
                    Text(vehicle.model)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(vehicle.vehicleStatusName == "Active" ? .green : .red)
                    Text(vehicle.vehicleStatusName ?? "Unknown")
                    Text("\u{2022}")
                    Text(vehicle.location ?? "Unknown")
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
