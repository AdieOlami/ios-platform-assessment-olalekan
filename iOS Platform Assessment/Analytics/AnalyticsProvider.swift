//
//  AnalyticsProvider.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

// MARK: - AnalyticsProviding

protocol AnalyticsProviding: AnyObject {
    /// Tracks a custom analytics event.
    ///
    /// Use this method to record user interactions, feature usage, or any custom events
    /// that are important for analytics. The event should contain all necessary
    /// metadata and properties for proper analysis.
    ///
    /// - Parameter event: The analytics event to track, containing event name and properties
    ///
    /// ## Example
    /// ```swift
    /// let event = AnalyticsEvent(name: "user_login", properties: ["method": "email"])
    /// analyticsProvider.track(event: event)
    /// ```
    func track(event: AnalyticsEvent)
    
    /// Tracks performance metrics with timing data.
    ///
    /// Use this method to monitor app performance, track operation durations,
    /// and identify performance bottlenecks. Common use cases include tracking
    /// view controller load times, network request durations, or database operations.
    ///
    /// - Parameters:
    ///   - metric: The performance metric type being tracked
    ///   - duration: The time interval (in seconds) for the operation
    ///   - properties: Additional context data for the performance metric
    ///
    /// ## Example
    /// ```swift
    /// analyticsProvider.track(
    ///     metric: .appStartTime,
    ///     duration: 0.35,
    ///     properties: ["screen": "ProfileViewController", "user_type": "premium"]
    /// )
    /// ```
    func track(metric: PerformanceMetric, duration: TimeInterval, properties: [String: Any])
    
    /// Tracks API-related metrics and performance data.
    ///
    /// Use this method to monitor API call performance, success rates, error rates,
    /// and response times. This helps identify API issues and optimize network performance.
    ///
    /// - Parameter apiMetric: The API metric containing endpoint, status, timing, and other relevant data
    ///
    /// ## Example
    /// ```swift
    /// let apiMetric = APIMetric(
    ///     endpoint: "/api/users/profile",
    ///     method: "GET",
    ///     statusCode: 200,
    ///     duration: 1.2,
    ///     success: true
    /// )
    /// analyticsProvider.track(apiMetric: apiMetric)
    /// ```
    func track(apiMetric: APIMetric)
    
    /// Tracks page/screen view metrics and user navigation patterns.
    ///
    /// Use this method to monitor user flow through app, track popular screens,
    /// measure time spent on pages, and understand user navigation patterns.
    ///
    /// - Parameter pageMetric: The page metric containing screen name, timing, and navigation context
    ///
    /// ## Example
    /// ```swift
    /// let pageMetric = PageMetric(
    ///     screenName: "ProductDetailsView",
    ///     loadTime: 45.0,
    ///     source: "HomeView"
    /// )
    /// analyticsProvider.track(pageMetric: pageMetric)
    /// ```
    func track(pageMetric: PageMetric)
    
    /// Forces immediate upload of all pending analytics data.
    ///
    /// Use this method when you need to ensure analytics data is sent immediately,
    /// such as when the app is about to terminate, go to background, or during
    /// critical user flows where data loss should be minimized.
    ///
    /// ## Note
    /// This operation may be asynchronous depending on the analytics provider implementation.
    /// Some providers may queue the flush request rather than executing it synchronously.
    ///
    /// ## Example
    /// ```swift
    /// // Before termination
    /// deinit {
    ///     analyticsProvider.flush()
    /// }
    /// ```
    func flush()
    
    /// Retrieves all analytics events currently stored locally.
    ///
    /// Use this method for debugging, testing, or implementing custom analytics
    /// data management. This is particularly useful in test environments to verify
    /// that expected events were tracked.
    ///
    /// - Returns: An array of all locally stored analytics events that haven't been uploaded yet
    ///
    /// ## Note
    /// The returned events may include events that are queued for upload but haven't
    /// been sent to the analytics service yet. This method should primarily be used
    /// for debugging and testing purposes.
    ///
    /// ## Example
    /// ```swift
    /// // In tests
    /// func testUserLoginTracking() {
    ///     // Perform login action
    ///     viewModel.login(email: "test@example.com", password: "password")
    ///
    ///     // Verify analytics event was tracked
    ///     let events = mockAnalyticsProvider.getStoredEvents()
    ///     XCTAssertTrue(events.contains { $0.name == "user_login" })
    /// }
    /// ```
    func getStoredEvents() -> [AnalyticsEvent]
}

// MARK: - AnalyticsProvider

final class AnalyticsProvider: AnalyticsProviding {
    
    // MARK: Lifecycle
    
    static let shared = AnalyticsProvider()
    
    private init() {
        setupPeriodicFlush()
    }
    
    // MARK: Internal
    
    func track(event: AnalyticsEvent) {
        queue.async { [weak self] in
            self?.events.append(event)
            self?.logEvent(event)
            
            // Auto-flush if we have too many events
            if let self = self, self.events.count >= self.maxEventsBeforeFlush {
                self.flush()
            }
        }
    }
    
    func track(metric: PerformanceMetric, duration: TimeInterval, properties: [String: Any] = [:]) {
        var eventProperties = properties
        eventProperties["metric_type"] = metric.rawValue
        eventProperties["duration_ms"] = Int(duration * 1000)
        
        let event = AnalyticsEvent(
            name: metric.rawValue,
            duration: duration,
            properties: eventProperties,
            category: .performance
        )
        
        track(event: event)
    }
    
    func track(apiMetric: APIMetric) {
        let event = AnalyticsEvent(
            name: PerformanceMetric.apiCallDuration.rawValue,
            duration: apiMetric.duration,
            properties: apiMetric.properties,
            category: .api
        )
        
        track(event: event)
    }
    
    func track(pageMetric: PageMetric) {
        let event = AnalyticsEvent(
            name: PerformanceMetric.pageLoadTime.rawValue,
            duration: pageMetric.loadTime,
            properties: pageMetric.properties,
            category: .navigation
        )
        
        track(event: event)
    }
    
    func flush() {
        queue.async { [weak self] in
            guard let self = self, !self.events.isEmpty else { return }
            
            let eventsToSend = self.events
            self.events.removeAll()
            
            self.sendEvents(eventsToSend)
        }
    }
    
    func getStoredEvents() -> [AnalyticsEvent] {
        return queue.sync { events }
    }
    
    // MARK: Private
    
    private let queue = DispatchQueue(label: "analytics.queue", qos: .utility)
    private var events: [AnalyticsEvent] = []
    private let maxEventsBeforeFlush = 50
    private let flushInterval: TimeInterval = 30.0 // 30 seconds
    private var flushTimer: Timer?
    
    private func setupPeriodicFlush() {
        DispatchQueue.main.async { [weak self] in
            self?.flushTimer = Timer.scheduledTimer(withTimeInterval: self?.flushInterval ?? 30.0, repeats: true) { _ in
                self?.flush()
            }
        }
    }
    
    private func sendEvents(_ events: [AnalyticsEvent]) {
        // In a complete implemetation, this would send to analytics service
        // For now, we'll just log and store locally
        
        print("📊 Analytics: Flushing \(events.count) events")
        
        for event in events {
            storeEventLocally(event)
        }
        
        // Simulate network call to analytics service
        // sendToRemoteAnalyticsService(events)
    }
    
    private func storeEventLocally(_ event: AnalyticsEvent) {
        // Store in UserDefaults for demonstration
        // In production, we might use Core Data/ a local database/ firebase database
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(EventData(from: event))
            let key = "analytics_event_\(event.id)"
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to store analytics event: \(error)")
        }
    }
    
    private func logEvent(_ event: AnalyticsEvent) {
        let durationString = event.duration.map { String(format: "%.2fms", $0 * 1000) } ?? "N/A"
        print("📊 Analytics Event: \(event.name) | Duration: \(durationString) | Category: \(event.category.rawValue)")
        
        if !event.properties.isEmpty {
            print("   Properties: \(event.properties)")
        }
    }
    
    deinit {
        flushTimer?.invalidate()
        flush()
    }
}

// MARK: - EventData

private struct EventData: Codable {
    let id: String
    let name: String
    let timestamp: Date
    let duration: TimeInterval?
    let category: String
    let properties: [String: String]
    
    init(from event: AnalyticsEvent) {
        self.id = event.id
        self.name = event.name
        self.timestamp = event.timestamp
        self.duration = event.duration
        self.category = event.category.rawValue
        
        self.properties = event.properties.mapValues { "\($0)" }
    }
}
