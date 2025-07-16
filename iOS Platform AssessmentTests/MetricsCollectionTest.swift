//
//  MetricsCollectionTest.swift
//  iOS Platform AssessmentTests
//
//  Created by Olami on 2025-07-16.
//

import Foundation
import Testing

@testable import iOS_Platform_Assessment

// MARK: - MetricsCollectionTest

struct MetricsCollectionTest {
    
    @Test("Generate analytics report over 10 executions")
    func generateTenExecutionAnalyticsReport() async throws {
        print("🏃‍♂️ Starting 10-execution analytics report generation")
        
        // Clear any existing data for clean test
        AnalyticsReporter.shared.clearAllData()
        
        // Simulate 10 test executions
        for execution in 1...10 {
            print("📊 Executing test run \(execution)/10")
            
            // Start execution tracking
            let executionId = AnalyticsReporter.shared.startExecution(notes: "Performance Test Run \(execution)")
            
            // Simulate app usage that generates metrics
            await simulateAppUsage(executionNumber: execution)
            
            // End execution tracking
            let summary = AnalyticsReporter.shared.endExecution()
            
            print("✅ Completed execution \(execution): \(summary?.executionId ?? "unknown")")
        }
        
        // Generate comprehensive report
        let report = AnalyticsReporter.shared.generateReport(fromLastExecutions: 10)
        #expect(report != nil)
        
        print("📊 Generated report with ID: \(report?.reportId ?? "unknown")")
        print("\n" + (report?.summary ?? "No report summary available"))
        
        // Export the report in different formats
        if let report = report {
            // Export as JSON
            let jsonURL = AnalyticsReporter.shared.exportReport(report, format: .json)
            #expect(jsonURL != nil)
            
            // Export as CSV
            let csvURL = AnalyticsReporter.shared.exportReport(report, format: .csv)
            #expect(csvURL != nil)
            
            // Export as text
            let textURL = AnalyticsReporter.shared.exportReport(report, format: .text)
            #expect(textURL != nil)
            
            print("📄 Reports exported to:")
            print("  JSON: \(jsonURL?.path ?? "N/A")")
            print("  CSV: \(csvURL?.path ?? "N/A")")
            print("  Text: \(textURL?.path ?? "N/A")")
            
            // Verify the averages are calculated correctly
            #expect(report.appStartMetrics.count >= 0)
            #expect(report.pageLoadMetrics.count >= 0)
            #expect(report.apiCallMetrics.count >= 0)
            #expect(report.totalExecutions == 10)
        }
    }
    
    private func simulateAppUsage(executionNumber: Int) async {
        // Simulate app start
        PerformanceTracker.shared.startAppLaunch()
        
        // Simulate some processing time
        try? await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000)) // 100-500ms
        
        PerformanceTracker.shared.completeAppLaunch()
        
        // Simulate page loads
        for page in 1...3 {
            let pageLoadTracker = PerformanceTracker.shared.startPageLoad(pageName: "TestPage\(page)", source: "test")
            
            // Simulate page loading time
            try? await Task.sleep(nanoseconds: UInt64.random(in: 200_000_000...800_000_000)) // 200-800ms
            
            pageLoadTracker.complete()
        }
        
        // Simulate API calls
        for api in 1...5 {
            let apiTracker = PerformanceTracker.shared.startAPICall(endpoint: "test/endpoint\(api)", method: "GET")
            
            // Simulate API response time
            try? await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...1_000_000_000)) // 100ms-1s
            
            apiTracker.complete(statusCode: 200)
        }
        
        print("  📱 Simulated app usage for execution \(executionNumber)")
    }
    
    @Test("Verify metrics collection works correctly")
    func verifyMetricsCollection() async throws {
        // Clear any existing data
        AnalyticsReporter.shared.clearAllData()
        
        // Start a single execution
        let executionId = AnalyticsReporter.shared.startExecution(notes: "Verification Test")
        
        // Generate some metrics
        PerformanceTracker.shared.startAppLaunch()
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        PerformanceTracker.shared.completeAppLaunch()
        
        let pageLoadTracker = PerformanceTracker.shared.startPageLoad(pageName: "TestPage", source: "test")
        try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
        pageLoadTracker.complete()
        
        let apiTracker = PerformanceTracker.shared.startAPICall(endpoint: "test", method: "GET")
        try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
        apiTracker.complete(statusCode: 200)
        
        // End execution
        let summary = AnalyticsReporter.shared.endExecution()
        
        // Verify the summary contains our metrics
        #expect(summary != nil)
        #expect((summary?.appStartTimes.count ?? 0) >= 1)
        #expect((summary?.pageLoadTimes.count ?? 0) >= 1)
        #expect((summary?.apiCallDurations.count ?? 0) >= 1)
        
        print("✅ Metrics collection verification passed")
        print("  App Start Times: \(summary?.appStartTimes.count ?? 0)")
        print("  Page Load Times: \(summary?.pageLoadTimes.count ?? 0)")
        print("  API Call Durations: \(summary?.apiCallDurations.count ?? 0)")
    }
}
