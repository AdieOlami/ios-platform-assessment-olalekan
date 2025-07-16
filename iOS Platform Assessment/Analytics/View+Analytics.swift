//
//  View+Analytics.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import SwiftUI

// MARK: - View

extension View {
    
    /// Track when a view appears with performance timing
    @ViewBuilder
    func trackViewAppearance(viewName: String) -> some View {
        // Skip analytics during UI testing to avoid test interference
        if ProcessInfo.processInfo.environment["IS_UI_TESTING"] == "1" {
            self
        } else {
            self.modifier(ViewAppearanceTracker(viewName: viewName))
        }
    }
    
    /// Track view render time
    @ViewBuilder
    func trackRenderTime(viewName: String) -> some View {
        // Skip analytics during UI testing to avoid test interference
        if ProcessInfo.processInfo.environment["IS_UI_TESTING"] == "1" {
            self
        } else {
            self.modifier(RenderTimeTracker(viewName: viewName))
        }
    }
}

// MARK: - ViewAppearanceTracker

struct ViewAppearanceTracker: ViewModifier {
    let viewName: String
    @State private var appearanceTime: CFAbsoluteTime = 0
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let renderTime = CFAbsoluteTimeGetCurrent() - appearanceTime
                if appearanceTime > 0 {
                    PerformanceTracker.shared.trackViewRender(
                        viewName: viewName,
                        duration: renderTime
                    )
                }
                
                AnalyticsProvider.shared.track(
                    event: AnalyticsEvent(
                        name: "view_appeared",
                        properties: ["view_name": viewName],
                        category: .navigation
                    )
                )
            }
            .onDisappear {
                AnalyticsProvider.shared.track(
                    event: AnalyticsEvent(
                        name: "view_disappeared",
                        properties: ["view_name": viewName],
                        category: .navigation
                    )
                )
            }
            .background(
                // Capture when the view starts rendering
                Color.clear.onAppear {
                    appearanceTime = CFAbsoluteTimeGetCurrent()
                }
            )
    }
}

// MARK: - RenderTimeTracker

struct RenderTimeTracker: ViewModifier {
    let viewName: String
    @State private var renderStartTime: CFAbsoluteTime = 0
    
    func body(content: Content) -> some View {
        content
            .background(
                Color.clear
                    .onAppear {
                        renderStartTime = CFAbsoluteTimeGetCurrent()
                    }
            )
            .onAppear {
                let renderTime = CFAbsoluteTimeGetCurrent() - renderStartTime
                PerformanceTracker.shared.trackViewRender(
                    viewName: viewName,
                    duration: renderTime
                )
            }
    }
}

// MARK: - Button

extension Button {
    
    /// Track button taps with analytics
    @ViewBuilder
    func trackTap(buttonName: String, additionalProperties: [String: Any] = [:]) -> some View {
        // Skip analytics during UI testing to avoid test interference
        if ProcessInfo.processInfo.environment["IS_UI_TESTING"] == "1" {
            self
        } else {
            self.onTapGesture {
                var properties = additionalProperties
                properties["button_name"] = buttonName
                properties["timestamp"] = Date().timeIntervalSince1970
                
                AnalyticsProvider.shared.track(
                    event: AnalyticsEvent(
                        name: "button_tapped",
                        properties: properties,
                        category: .userInteraction
                    )
                )
            }
        }
    }
}

// MARK: - NavigationLink

extension NavigationLink {
    
    /// Track navigation events
    @ViewBuilder
    func trackNavigation(destination: String, source: String) -> some View {
        // Skip analytics during UI testing to avoid test interference
        if ProcessInfo.processInfo.environment["IS_UI_TESTING"] == "1" {
            self
        } else {
            self.onTapGesture {
                AnalyticsProvider.shared.track(
                    event: AnalyticsEvent(
                        name: "navigation_tapped",
                        properties: [
                            "destination": destination,
                            "source": source,
                            "timestamp": Date().timeIntervalSince1970
                        ],
                        category: .navigation
                    )
                )
            }
        }
    }
}
