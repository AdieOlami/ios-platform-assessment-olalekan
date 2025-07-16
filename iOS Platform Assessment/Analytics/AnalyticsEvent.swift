//
//  AnalyticsEvent.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

// MARK: - AnalyticsEvent

struct AnalyticsEvent {
    let id: String
    let name: String
    let timestamp: Date
    let duration: TimeInterval?
    let properties: [String: Any]
    let category: AnalyticsCategory
    
    init(
        name: String,
        duration: TimeInterval? = nil,
        properties: [String: Any] = [:],
        category: AnalyticsCategory
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.timestamp = Date()
        self.duration = duration
        self.properties = properties
        self.category = category
    }
}

// MARK: - AnalyticsCategory

enum AnalyticsCategory: String, CaseIterable {
    case performance = "performance"
    case userInteraction = "user_interaction"
    case navigation = "navigation"
    case api = "api"
    case error = "error"
}

// MARK: - PerformanceMetric

enum PerformanceMetric: String {
    case appStartTime = "app_start_time"
    case pageLoadTime = "page_load_time"
    case apiCallDuration = "api_call_duration"
    case viewRenderTime = "view_render_time"
    case searchResponseTime = "search_response_time"
}

// MARK: - APIMetric

struct APIMetric {
    let endpoint: String
    let method: String
    let statusCode: Int?
    let duration: TimeInterval
    let success: Bool
    let errorMessage: String?
    
    var properties: [String: Any] {
        var props: [String: Any] = [
            "endpoint": endpoint,
            "method": method,
            "duration": duration,
            "success": success
        ]
        
        if let statusCode = statusCode {
            props["status_code"] = statusCode
        }
        
        if let errorMessage = errorMessage {
            props["error_message"] = errorMessage
        }
        
        return props
    }
}

// MARK: - PageMetric

struct PageMetric {
    let screenName: String
    let loadTime: TimeInterval
    let source: String?
    
    var properties: [String: Any] {
        var props: [String: Any] = [
            "screen_name": screenName,
            "load_time": loadTime
        ]
        
        if let source = source {
            props["source"] = source
        }
        
        return props
    }
}
