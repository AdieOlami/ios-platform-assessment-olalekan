import Foundation
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        TabView {
            Image("fleetio-logo")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                        .accessibilityIdentifier(AccessibilityIdentifiers.HomeView.browseTab)
                }
            Text("Notifications")
                .tabItem {
                    Label("Notifications", systemImage: "bell.badge.fill")
                }
            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            #if DEBUG
            AnalyticsDashboard()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
            #endif
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
