import Foundation
import SwiftUI

// MARK: - BrowseItem

struct BrowseItem {
    let name: String
    let iconName: String
}

// MARK: - BrowseView

struct BrowseView: View {
    
    // MARK: Internal
    
    var body: some View {
        NavigationStack(path: $routes) {
            List {
                Section(header: Text("Assets")) {
                    ForEach(assets, id: \.name) { asset in
                        NavigationLink(value: asset.name) {
                            HStack {
                                Image(systemName: asset.iconName)
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                                Text(asset.name)
                            }
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.BrowseView.browseListItem(type: asset.name))
                    }
                }
                
                Section(header: Text("Work")) {
                    ForEach(work, id: \.name) { item in
                        NavigationLink(destination: Text(item.name)) {
                            HStack {
                                Image(systemName: item.iconName)
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                                Text(item.name)
                            }
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.BrowseView.browseListItem(type: item.name))
                    }
                }
                
                Section(header: Text("Directories")) {
                    ForEach(directories, id: \.name) { item in
                        NavigationLink(destination: Text(item.name)) {
                            HStack {
                                Image(systemName: item.iconName)
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                                Text(item.name)
                            }
                        }
                        .accessibilityIdentifier(AccessibilityIdentifiers.BrowseView.browseListItem(type: item.name))
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Browse")
            .navigationDestination(for: String.self) { route in
                switch route {
                case "Vehicles":
                    VehicleList(viewModel: VehicleListViewModel())
                default:
                    Text(route)
                }
            }
        }
    }
    
    // MARK: Private
    
    @State private var routes = NavigationPath()
    
    private let assets: [BrowseItem] = [
        BrowseItem(name: "Equipment", iconName: "hammer"),
        BrowseItem(name: "Parts", iconName: "shippingbox"),
        BrowseItem(name: "Vehicles", iconName: "car"),
    ]
    
    private let work: [BrowseItem] = [
        BrowseItem(name: "Inspections", iconName: "checkmark.circle"),
        BrowseItem(name: "Issues", iconName: "exclamationmark.triangle"),
        BrowseItem(name: "Service Reminders", iconName: "alarm"),
        BrowseItem(name: "Work Orders", iconName: "list.clipboard"),
    ]
    
    private let directories: [BrowseItem] = [
        BrowseItem(name: "Contacts", iconName: "person.2"),
        BrowseItem(name: "Shop Directory", iconName: "wrench.adjustable"),
    ]
}

// MARK: - Preview

#Preview {
    BrowseView()
}
