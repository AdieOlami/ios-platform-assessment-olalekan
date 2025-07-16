//
//  PerformanceTracker.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation
import UIKit

// MARK: - PerformanceTracker

final class PerformanceTracker {
    
    // MARK: Lifecycle
    
    static let shared = PerformanceTracker()
    
    private init() {
        setupAppStartTracking()
    }
    
    // MARK: Internal
    
    /// Start tracking app launch time
    func startAppLaunch() {
        appLaunchStartTime = CFAbsoluteTimeGetCurrent()
    }
    
    /// Complete app launch tracking
    func completeAppLaunch() {
        guard let startTime = appLaunchStartTime else { return }
        
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        
        AnalyticsProvider.shared.track(
            metric: .appStartTime,
            duration: duration,
            properties: [
                "launch_type": isWarmLaunch ? "warm" : "cold",
                "device_model": UIDevice.current.model,
                "os_version": UIDevice.current.systemVersion
            ]
        )
        
        appLaunchStartTime = nil
        isWarmLaunch = true // Subsequent launches are warm
    }
    
    /// Start tracking page load time
    @discardableResult
    func startPageLoad(pageName: String, source: String? = nil) -> PageLoadTracker {
        return PageLoadTracker(pageName: pageName, source: source)
    }
    
    /// Start tracking API call duration
    @discardableResult
    func startAPICall(endpoint: String, method: String = "GET") -> APICallTracker {
        return APICallTracker(endpoint: endpoint, method: method)
    }
    
    /// Track view render time
    func trackViewRender(viewName: String, duration: TimeInterval) {
        AnalyticsProvider.shared.track(
            metric: .viewRenderTime,
            duration: duration,
            properties: [
                "view_name": viewName,
                "render_time_ms": Int(duration * 1000)
            ]
        )
    }
    
    /// Track search response time
    func trackSearchResponse(query: String, resultCount: Int, duration: TimeInterval) {
        AnalyticsProvider.shared.track(
            metric: .searchResponseTime,
            duration: duration,
            properties: [
                "query": query,
                "result_count": resultCount,
                "query_length": query.count
            ]
        )
    }
    
    // MARK: Private
    
    private var appLaunchStartTime: CFAbsoluteTime?
    private var isWarmLaunch = false
    
    private func setupAppStartTracking() {
        // Track when app becomes active
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // Only track first launch
            if self?.appLaunchStartTime != nil {
                self?.completeAppLaunch()
            }
        }
    }
}

// MARK: - PageLoadTracker

final class PageLoadTracker {
    
    // MARK: Lifecycle
    
    init(pageName: String, source: String? = nil) {
        self.pageName = pageName
        self.source = source
        self.startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: Internal
    
    func complete() {
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        
        let pageMetric = PageMetric(
            screenName: pageName,
            loadTime: duration,
            source: source
        )
        
        AnalyticsProvider.shared.track(pageMetric: pageMetric)
    }
    
    // MARK: Private
    
    private let pageName: String
    private let source: String?
    private let startTime: CFAbsoluteTime
}

// MARK: - APICallTracker

final class APICallTracker {
    
    // MARK: Lifecycle
    
    init(endpoint: String, method: String) {
        self.endpoint = endpoint
        self.method = method
        self.startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: Internal
    
    func complete(statusCode: Int? = nil, error: Error? = nil) {
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        let success = error == nil && (statusCode == nil || (200...299).contains(statusCode!))
        
        let apiMetric = APIMetric(
            endpoint: endpoint,
            method: method,
            statusCode: statusCode,
            duration: duration,
            success: success,
            errorMessage: error?.localizedDescription
        )
        
        AnalyticsProvider.shared.track(apiMetric: apiMetric)
    }
    
    // MARK: Private
    
    private let endpoint: String
    private let method: String
    private let startTime: CFAbsoluteTime
}
