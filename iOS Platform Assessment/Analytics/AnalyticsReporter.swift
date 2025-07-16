//
//  AnalyticsReporter.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-16.
//

import Foundation

// MARK: - MetricsReport

/// A comprehensive report containing aggregated analytics metrics over multiple test runs
struct MetricsReport: Codable {
    let reportId: String
    let generatedAt: Date
    let totalExecutions: Int
    let executionRange: DateInterval
    let appStartMetrics: MetricSummary
    let pageLoadMetrics: MetricSummary
    let apiCallMetrics: MetricSummary
    let executionDetails: [TestExecutionSummary]
    
    /// Human-readable summary of the report
    var summary: String {
        return """
        📊 Analytics Report
        ==================
        Report ID: \(reportId)
        Generated: \(DateFormatter.reportFormatter.string(from: generatedAt))
        Total Executions: \(totalExecutions)
        Execution Period: \(DateFormatter.reportFormatter.string(from: executionRange.start)) - \(DateFormatter.reportFormatter.string(from: executionRange.end))
        
        📱 App Start Time
        - Average: \(String(format: "%.2f", appStartMetrics.average))ms
        - Median: \(String(format: "%.2f", appStartMetrics.median))ms
        - Min: \(String(format: "%.2f", appStartMetrics.minimum))ms
        - Max: \(String(format: "%.2f", appStartMetrics.maximum))ms
        - Standard Deviation: \(String(format: "%.2f", appStartMetrics.standardDeviation))ms
        
        📄 Page Load Time
        - Average: \(String(format: "%.2f", pageLoadMetrics.average))ms
        - Median: \(String(format: "%.2f", pageLoadMetrics.median))ms
        - Min: \(String(format: "%.2f", pageLoadMetrics.minimum))ms
        - Max: \(String(format: "%.2f", pageLoadMetrics.maximum))ms
        - Standard Deviation: \(String(format: "%.2f", pageLoadMetrics.standardDeviation))ms
        
        🌐 API Call Duration
        - Average: \(String(format: "%.2f", apiCallMetrics.average))ms
        - Median: \(String(format: "%.2f", apiCallMetrics.median))ms
        - Min: \(String(format: "%.2f", apiCallMetrics.minimum))ms
        - Max: \(String(format: "%.2f", apiCallMetrics.maximum))ms
        - Standard Deviation: \(String(format: "%.2f", apiCallMetrics.standardDeviation))ms
        """
    }
    
    /// CSV format for exporting to external tools
    var csvData: String {
        var csv = "Metric,Average,Median,Min,Max,StdDev,Count\n"
        csv += "App Start Time,\(appStartMetrics.average),\(appStartMetrics.median),\(appStartMetrics.minimum),\(appStartMetrics.maximum),\(appStartMetrics.standardDeviation),\(appStartMetrics.count)\n"
        csv += "Page Load Time,\(pageLoadMetrics.average),\(pageLoadMetrics.median),\(pageLoadMetrics.minimum),\(pageLoadMetrics.maximum),\(pageLoadMetrics.standardDeviation),\(pageLoadMetrics.count)\n"
        csv += "API Call Duration,\(apiCallMetrics.average),\(apiCallMetrics.median),\(apiCallMetrics.minimum),\(apiCallMetrics.maximum),\(apiCallMetrics.standardDeviation),\(apiCallMetrics.count)\n"
        return csv
    }
}

// MARK: - MetricSummary

struct MetricSummary: Codable {
    let average: Double
    let median: Double
    let minimum: Double
    let maximum: Double
    let standardDeviation: Double
    let count: Int
    let values: [Double]
    
    init(values: [Double]) {
        self.values = values
        self.count = values.count
        
        if values.isEmpty {
            self.average = 0
            self.median = 0
            self.minimum = 0
            self.maximum = 0
            self.standardDeviation = 0
        } else {
            let sorted = values.sorted()
            let avg = values.reduce(0, +) / Double(values.count)
            self.average = avg
            self.median = sorted.count % 2 == 0 
                ? (sorted[sorted.count / 2 - 1] + sorted[sorted.count / 2]) / 2
                : sorted[sorted.count / 2]
            self.minimum = sorted.first ?? 0
            self.maximum = sorted.last ?? 0
            
            // Calculate standard deviation
            let variance = values.reduce(0) { sum, value in
                sum + pow(value - avg, 2)
            } / Double(values.count)
            self.standardDeviation = sqrt(variance)
        }
    }
}

// MARK: - TestExecutionSummary

struct TestExecutionSummary: Codable {
    let executionId: String
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let appStartTimes: [Double]
    let pageLoadTimes: [Double]
    let apiCallDurations: [Double]
    let eventCount: Int
    let success: Bool
    let notes: String?
    
    var durationMs: Double {
        return duration * 1000
    }
}

// MARK: - AnalyticsReporter

final class AnalyticsReporter {
    
    // MARK: Lifecycle
    
    static let shared = AnalyticsReporter()
    
    private init() {}
    
    // MARK: Internal
    
    /// Starts a new test execution session for metrics collection
    func startExecution(notes: String? = nil) -> String {
        let executionId = UUID().uuidString
        let execution = ExecutionSession(
            id: executionId,
            startTime: Date(),
            notes: notes
        )
        
        currentExecution = execution
        print("📊 Analytics Reporter: Started execution \(executionId)")
        
        return executionId
    }
    
    /// Ends the current test execution session
    func endExecution() -> TestExecutionSummary? {
        guard let execution = currentExecution else {
            print("⚠️ Analytics Reporter: No active execution to end")
            return nil
        }
        
        let endTime = Date()
        let events = AnalyticsProvider.shared.getStoredEvents()
        
        // Extract metrics from events
        let appStartTimes = extractMetrics(from: events, ofType: .appStartTime)
        let pageLoadTimes = extractMetrics(from: events, ofType: .pageLoadTime)
        let apiCallDurations = extractMetrics(from: events, ofType: .apiCallDuration)
        
        let summary = TestExecutionSummary(
            executionId: execution.id,
            startTime: execution.startTime,
            endTime: endTime,
            duration: endTime.timeIntervalSince(execution.startTime),
            appStartTimes: appStartTimes,
            pageLoadTimes: pageLoadTimes,
            apiCallDurations: apiCallDurations,
            eventCount: events.count,
            success: true, // You could add logic to determine success based on criteria
            notes: execution.notes
        )
        
        // Store the execution summary
        storeExecutionSummary(summary)
        
        currentExecution = nil
        print("📊 Analytics Reporter: Ended execution \(execution.id)")
        
        return summary
    }
    
    /// Generates a comprehensive report from multiple test executions
    func generateReport(fromLastExecutions count: Int = 10) -> MetricsReport? {
        let executions = getStoredExecutions().suffix(count)
        
        guard !executions.isEmpty else {
            print("⚠️ Analytics Reporter: No executions found for report generation")
            return nil
        }
        
        // Aggregate all metrics
        let allAppStartTimes = executions.flatMap { $0.appStartTimes }
        let allPageLoadTimes = executions.flatMap { $0.pageLoadTimes }
        let allApiCallDurations = executions.flatMap { $0.apiCallDurations }
        
        // Calculate date range
        let startDate = executions.map { $0.startTime }.min() ?? Date()
        let endDate = executions.map { $0.endTime }.max() ?? Date()
        
        let report = MetricsReport(
            reportId: UUID().uuidString,
            generatedAt: Date(),
            totalExecutions: executions.count,
            executionRange: DateInterval(start: startDate, end: endDate),
            appStartMetrics: MetricSummary(values: allAppStartTimes),
            pageLoadMetrics: MetricSummary(values: allPageLoadTimes),
            apiCallMetrics: MetricSummary(values: allApiCallDurations),
            executionDetails: Array(executions)
        )
        
        // Store the report
        storeReport(report)
        
        print("📊 Analytics Reporter: Generated report \(report.reportId) from \(executions.count) executions")
        
        return report
    }
    
    /// Exports the latest report to a file for CI/CD or manual review
    func exportLatestReport(format: ExportFormat = .json) -> URL? {
        guard let report = getLatestReport() else {
            print("⚠️ Analytics Reporter: No report found to export")
            return nil
        }
        
        return exportReport(report, format: format)
    }
    
    /// Exports a specific report to a file
    func exportReport(_ report: MetricsReport, format: ExportFormat = .json) -> URL? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let reportsURL = documentsURL.appendingPathComponent("AnalyticsReports", isDirectory: true)
        
        // Create reports directory if it doesn't exist
        try? fileManager.createDirectory(at: reportsURL, withIntermediateDirectories: true)
        
        let fileName: String
        let fileContent: Data
        
        switch format {
        case .json:
            fileName = "analytics_report_\(report.reportId).json"
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = .prettyPrinted
                fileContent = try encoder.encode(report)
            } catch {
                print("❌ Failed to encode report as JSON: \(error)")
                return nil
            }
            
        case .csv:
            fileName = "analytics_report_\(report.reportId).csv"
            fileContent = report.csvData.data(using: .utf8) ?? Data()
            
        case .text:
            fileName = "analytics_report_\(report.reportId).txt"
            fileContent = report.summary.data(using: .utf8) ?? Data()
        }
        
        let fileURL = reportsURL.appendingPathComponent(fileName)
        
        do {
            try fileContent.write(to: fileURL)
            print("📄 Analytics Reporter: Exported report to \(fileURL.path)")
            return fileURL
        } catch {
            print("❌ Failed to write report to file: \(error)")
            return nil
        }
    }
    
    /// Gets all stored execution summaries
    func getStoredExecutions() -> [TestExecutionSummary] {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.hasPrefix("analytics_execution_") }
        
        return keys.compactMap { key in
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            return try? JSONDecoder.reportDecoder.decode(TestExecutionSummary.self, from: data)
        }.sorted { $0.startTime < $1.startTime }
    }
    
    /// Gets all stored reports
    func getStoredReports() -> [MetricsReport] {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.hasPrefix("analytics_report_") }
        
        return keys.compactMap { key in
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            return try? JSONDecoder.reportDecoder.decode(MetricsReport.self, from: data)
        }.sorted { $0.generatedAt < $1.generatedAt }
    }
    
    /// Gets the most recent report
    func getLatestReport() -> MetricsReport? {
        return getStoredReports().last
    }
    
    /// Clears all stored analytics data (use with caution)
    func clearAllData() {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.hasPrefix("analytics_") }
        
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        print("🗑 Analytics Reporter: Cleared all stored data")
    }
    
    // MARK: Private
    
    private var currentExecution: ExecutionSession?
    
    private struct ExecutionSession {
        let id: String
        let startTime: Date
        let notes: String?
    }
    
    private func extractMetrics(from events: [AnalyticsEvent], ofType metricType: PerformanceMetric) -> [Double] {
        return events
            .filter { $0.name == metricType.rawValue }
            .compactMap { $0.duration }
            .map { $0 * 1000 } // Convert to milliseconds
    }
    
    private func storeExecutionSummary(_ summary: TestExecutionSummary) {
        do {
            let data = try JSONEncoder.reportEncoder.encode(summary)
            let key = "analytics_execution_\(summary.executionId)"
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to store execution summary: \(error)")
        }
    }
    
    private func storeReport(_ report: MetricsReport) {
        do {
            let data = try JSONEncoder.reportEncoder.encode(report)
            let key = "analytics_report_\(report.reportId)"
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to store report: \(error)")
        }
    }
}

// MARK: - ExportFormat

enum ExportFormat {
    case json
    case csv
    case text
}

// MARK: - Extensions

private extension JSONEncoder {
    static let reportEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
}

private extension JSONDecoder {
    static let reportDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

private extension DateFormatter {
    static let reportFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
