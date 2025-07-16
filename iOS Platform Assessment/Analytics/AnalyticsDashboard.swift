//
//  AnalyticsDashboard.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import SwiftUI

// MARK: - AnalyticsDashboard

struct AnalyticsDashboard: View {
    
    // MARK: Lifecycle
    
    init() {}
    
    // MARK: Internal
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    
                    // Performance Metrics Section
                    AnalyticsSection(title: "Performance Metrics") {
                        PerformanceMetricsView()
                    }
                    
                    // API Metrics Section
                    AnalyticsSection(title: "API Performance") {
                        APIMetricsView()
                    }
                    
                    // Page Load Metrics Section
                    AnalyticsSection(title: "Page Load Times") {
                        PageLoadMetricsView()
                    }
                    
                    // Recent Events Section
                    AnalyticsSection(title: "Recent Events") {
                        RecentEventsView()
                    }
                    
                    // Actions Section
                    AnalyticsSection(title: "Actions") {
                        ActionsView()
                    }
                }
                .padding()
            }
            .navigationTitle("Analytics Dashboard")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - AnalyticsSection

struct AnalyticsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - PerformanceMetricsView

struct PerformanceMetricsView: View {
    @State private var events: [AnalyticsEvent] = []
    
    var body: some View {
        VStack(spacing: 8) {
            if let appStartEvent = events.first(where: { $0.name == PerformanceMetric.appStartTime.rawValue }) {
                MetricRow(
                    title: "App Start Time",
                    value: formatDuration(appStartEvent.duration),
                    icon: "stopwatch"
                )
            }
            
            let avgPageLoad = averageDuration(for: .pageLoadTime)
            if avgPageLoad > 0 {
                MetricRow(
                    title: "Avg Page Load",
                    value: formatDuration(avgPageLoad),
                    icon: "clock"
                )
            }
            
            let avgAPICall = averageDuration(for: .apiCallDuration)
            if avgAPICall > 0 {
                MetricRow(
                    title: "Avg API Call",
                    value: formatDuration(avgAPICall),
                    icon: "network"
                )
            }
        }
        .onAppear {
            refreshEvents()
        }
    }
    
    private func averageDuration(for metric: PerformanceMetric) -> TimeInterval {
        let metricEvents = events.filter { $0.name == metric.rawValue }
        guard !metricEvents.isEmpty else { return 0 }
        
        let totalDuration = metricEvents.compactMap { $0.duration }.reduce(0, +)
        return totalDuration / Double(metricEvents.count)
    }
    
    private func refreshEvents() {
        events = AnalyticsProvider.shared.getStoredEvents()
    }
    
    private func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration = duration else { return "N/A" }
        return String(format: "%.0fms", duration * 1000)
    }
}

// MARK: - APIMetricsView

struct APIMetricsView: View {
    @State private var events: [AnalyticsEvent] = []
    
    var body: some View {
        VStack(spacing: 8) {
            let apiEvents = events.filter { $0.category == .api }
            
            if !apiEvents.isEmpty {
                let successCount = apiEvents.filter { $0.properties["success"] as? Bool == true }.count
                let successRate = Double(successCount) / Double(apiEvents.count) * 100
                
                MetricRow(
                    title: "API Success Rate",
                    value: String(format: "%.1f%%", successRate),
                    icon: "checkmark.circle"
                )
                
                MetricRow(
                    title: "Total API Calls",
                    value: "\(apiEvents.count)",
                    icon: "arrow.up.arrow.down"
                )
                
                if let avgDuration = apiEvents.compactMap({ $0.duration }).average {
                    MetricRow(
                        title: "Avg Response Time",
                        value: String(format: "%.0fms", avgDuration * 1000),
                        icon: "timer"
                    )
                }
            } else {
                Text("No API metrics available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .onAppear {
            events = AnalyticsProvider.shared.getStoredEvents()
        }
    }
}

// MARK: - PageLoadMetricsView

struct PageLoadMetricsView: View {
    @State private var events: [AnalyticsEvent] = []
    
    var body: some View {
        VStack(spacing: 8) {
            let pageEvents = events.filter { $0.name == PerformanceMetric.pageLoadTime.rawValue }
            
            if !pageEvents.isEmpty {
                ForEach(pageEvents.prefix(5), id: \.id) { event in
                    if let pageName = event.properties["page_name"] as? String,
                       let duration = event.duration {
                        MetricRow(
                            title: pageName,
                            value: String(format: "%.0fms", duration * 1000),
                            icon: "doc.text"
                        )
                    }
                }
            } else {
                Text("No page load metrics available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .onAppear {
            events = AnalyticsProvider.shared.getStoredEvents()
        }
    }
}

// MARK: - RecentEventsView

struct RecentEventsView: View {
    @State private var events: [AnalyticsEvent] = []
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(events.prefix(5), id: \.id) { event in
                EventRow(event: event)
            }
            
            if events.isEmpty {
                Text("No recent events")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .onAppear {
            events = AnalyticsProvider.shared.getStoredEvents()
                .sorted { $0.timestamp > $1.timestamp }
        }
    }
}

// MARK: - ActionsView

struct ActionsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Button("Flush Events") {
                AnalyticsProvider.shared.flush()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Clear Local Data") {
                clearLocalAnalyticsData()
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func clearLocalAnalyticsData() {
        let defaults = UserDefaults.standard
        let keys = defaults.dictionaryRepresentation().keys.filter { $0.hasPrefix("analytics_event_") }
        for key in keys {
            defaults.removeObject(forKey: key)
        }
    }
}

// MARK: - MetricRow

struct MetricRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - EventRow

struct EventRow: View {
    let event: AnalyticsEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(event.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if let duration = event.duration {
                    Text(String(format: "%.0fms", duration * 1000))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text(event.category.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(categoryColor(event.category))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                
                Spacer()
                
                Text(event.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func categoryColor(_ category: AnalyticsCategory) -> Color {
        switch category {
        case .performance: return .blue
        case .api: return .green
        case .navigation: return .orange
        case .userInteraction: return .purple
        case .error: return .red
        }
    }
}

// MARK: - Array

extension Array where Element == TimeInterval {
    var average: TimeInterval? {
        guard !isEmpty else { return nil }
        return reduce(0, +) / Double(count)
    }
}

// MARK: - Preview

#Preview {
    AnalyticsDashboard()
}
