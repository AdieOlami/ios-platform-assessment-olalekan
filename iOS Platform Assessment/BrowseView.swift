import Foundation
import SwiftUI

struct BrowseItem {
    let name: String
    let iconName: String
}

struct BrowseView: View {
    
    let assets: [BrowseItem] = [
        BrowseItem(name: "Equipment", iconName: "hammer"),
        BrowseItem(name: "Parts", iconName: "shippingbox"),
        BrowseItem(name: "Vehicles", iconName: "car"),
    ]
    
    let work: [BrowseItem] = [
        BrowseItem(name: "Inspections", iconName: "checkmark.circle"),
        BrowseItem(name: "Issues", iconName: "exclamationmark.triangle"),
        BrowseItem(name: "Service Reminders", iconName: "alarm"),
        BrowseItem(name: "Work Orders", iconName: "list.clipboard"),
    ]
    
    let directories: [BrowseItem] = [
        BrowseItem(name: "Contacts", iconName: "person.2"),
        BrowseItem(name: "Shop Directory", iconName: "wrench.adjustable"),
    ]
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Assets")) {
                    ForEach(assets, id: \.name) { asset in
                        NavigationLink(destination: navigationDestination(for: asset)) {
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
        }
    }
    
    func navigationDestination(for item: BrowseItem) -> some View {
        
        if item.name == "Vehicles" {
            AnyView(VehicleList())
        } else {
            AnyView(Text(item.name))
        }
    }
}

#Preview {
    BrowseView()
}
