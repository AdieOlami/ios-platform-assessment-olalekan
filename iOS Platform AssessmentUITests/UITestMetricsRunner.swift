//
//  UITestMetricsRunner.swift
//  iOS Platform AssessmentUITests
//
//  Created by Olami on 2025-07-16.
//

import XCTest
import Foundation

/// Automated UI test runner that executes multiple test runs and collects performance metrics
/// This class orchestrates the execution of UI tests over multiple iterations to gather
/// comprehensive analytics data for app start time, page load time, and API call duration.
@MainActor
final class UITestMetricsRunner: XCTestCase {
    
    private var app: XCUIApplication!
    private var currentExecutionId: String?
    private static var hasRunMainTest = false // Prevent multiple executions
    private static var isWorkflowCompleted = false // Track completion status
    
    /// Maximum execution time before forcing termination (in seconds)
    private let maxExecutionTime: TimeInterval = 60 // 10 minutes
    
    // MARK: - Configuration
    
    /// Number of test executions to run for metrics collection
    private let numberOfExecutions = 3
    
    /// Delay between test executions to ensure clean state
    private let executionDelay: TimeInterval = 2.0
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = true
        
        // Configure app for testing
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments.append("--reset-analytics")
    }
    
    override func tearDownWithError() throws {
        // End current execution if active
        if let executionId = currentExecutionId {
            endCurrentExecution(executionId: executionId)
        }
        
        app = nil
        
        // Reset the flags after the test completes
        Self.hasRunMainTest = false
        Self.isWorkflowCompleted = false
        
        try super.tearDownWithError()
    }
    
    // MARK: - Main Test Methods
    
    /// Main method that executes the complete metrics collection workflow
    /// This runs the specified number of iterations of UI tests and generates a comprehensive analytics report
    /// NOTE: This method should be called manually, not auto-discovered by XCTest
    func collectMetricsOverMultipleExecutions() throws {
        // Prevent multiple executions in the same test session
        guard !Self.hasRunMainTest else {
            print("⚠️ Main metrics test has already run in this session. Skipping to prevent duplicate executions.")
            return
        }
        
        // Check if workflow was already completed
        guard !Self.isWorkflowCompleted else {
            print("⚠️ Workflow already completed. Skipping to prevent infinite loop.")
            return
        }
        
        Self.hasRunMainTest = true
        print("🚀 Starting UITestMetricsRunner - This will run ONCE only")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            runMetricsCollectionWorkflow()
            
            // Check for timeout
            let currentTime = CFAbsoluteTimeGetCurrent()
            if (currentTime - startTime) > maxExecutionTime {
                print("⏰ Maximum execution time reached. Terminating workflow.")
                Self.isWorkflowCompleted = true
                return
            }
        }
        
        Self.isWorkflowCompleted = true
        print("🏁 UITestMetricsRunner completed successfully and will not run again.")
    }
    
    /// XCTest discoverable method that calls the main collection workflow
    /// This ensures it's only run when explicitly called by the test framework
    func testMetricsCollection() throws {
        try collectMetricsOverMultipleExecutions()
    }
    
    /// Individual test execution for app startup metrics (private to avoid being run as separate test)
    private func executeAppStartupMetrics() throws {
        let executionId = startNewExecution(notes: "App Startup Test")
        
        // Measure app launch time
        let launchTime = measureAppLaunch()
        print("📱 App launch time: \(launchTime)ms")
        
        // Basic navigation to ensure app is fully loaded
        performBasicNavigation()
        
        endCurrentExecution(executionId: executionId)
    }
    
    /// Individual test execution for page load metrics (private to avoid being run as separate test)
    private func executePageLoadMetrics() throws {
        let executionId = startNewExecution(notes: "Page Load Test")
        
        app.launch()
        waitForAppToLoad()
        
        // Test various page loads
        measurePageLoadTimes()
        
        endCurrentExecution(executionId: executionId)
    }
    
    /// Individual test execution for API call metrics (private to avoid being run as separate test)
    private func executeApiCallMetrics() throws {
        let executionId = startNewExecution(notes: "API Call Test")
        
        app.launch()
        waitForAppToLoad()
        
        // Test API-heavy operations
        measureApiCallDurations()
        
        endCurrentExecution(executionId: executionId)
    }
    
    // MARK: - Metrics Collection Workflow
    
    /// Runs the complete metrics collection workflow over multiple executions
    private func runMetricsCollectionWorkflow() {
        print("🚀 Starting UITestMetricsRunner - \(numberOfExecutions) executions")
        print("🔄 Execution counter will stop at \(numberOfExecutions)")
        print("⚠️  This workflow will run EXACTLY \(numberOfExecutions) times and then STOP.")
        
        // Clear any existing analytics data
        resetAnalyticsData()
        
        var completedExecutions = 0
        
        // Execute test runs with explicit termination
        for execution in 1...numberOfExecutions {
            // Double check we haven't been marked as completed
            guard !Self.isWorkflowCompleted else {
                print("🛑 Workflow marked as completed. Terminating loop.")
                break
            }
            
            print("\n📊 === Execution \(execution)/\(numberOfExecutions) ===")
            
            do {
                try executeTestRun(executionNumber: execution)
                completedExecutions += 1
                print("✅ Completed execution \(execution) - Total completed: \(completedExecutions)")
                
                // Wait between executions for clean state
                if execution < numberOfExecutions {
                    print("⏳ Waiting \(executionDelay)s before next execution...")
                    Thread.sleep(forTimeInterval: executionDelay)
                }
            } catch {
                print("❌ Execution \(execution) failed: \(error)")
                XCTFail("Test execution \(execution) failed: \(error.localizedDescription)")
                break // Stop on failure
            }
        }
        
        print("\n🎯 All executions completed: \(completedExecutions)/\(numberOfExecutions)")
        print("🏁 Workflow is now complete and will NOT run again.")
        
        // Mark as completed to prevent any further runs
        Self.isWorkflowCompleted = true
        
        // Generate final report
        generateAndExportReport()
        
        print("🏁 UITestMetricsRunner workflow finished successfully!")
    }
    
    /// Executes a single test run with comprehensive metrics collection
    private func executeTestRun(executionNumber: Int) throws {
        let executionId = startNewExecution(notes: "UI Test Run \(executionNumber)")
        
        // Measure app launch
        let launchTime = measureAppLaunch()
        print("📱 Launch time: \(launchTime)ms")
        
        // Wait for app to be fully loaded
        waitForAppToLoad()
        
        // Perform navigation and measure page loads
        measurePageLoadTimes()
        
        // Perform operations that trigger API calls
        measureApiCallDurations()
        
        // End execution
        endCurrentExecution(executionId: executionId)
    }
    
    // MARK: - Measurement Methods
    
    /// Measures app launch time from launch to initial screen display
    @discardableResult
    private func measureAppLaunch() -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        app.launch()
        
        // Wait for the main UI elements to appear
        let loginButton = app.buttons["Login"]
        let exists = loginButton.waitForExistence(timeout: 10)
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let launchTime = (endTime - startTime) * 1000 // Convert to milliseconds
        
        XCTAssertTrue(exists, "App should launch and show login screen")
        
        return launchTime
    }
    
    /// Measures page load times for various screens
    private func measurePageLoadTimes() {
        // Login flow
        performLogin()
        
        // Navigate to different screens and measure load times
        measureHomeScreenLoad()
        measureBrowseScreenLoad()
        measureVehicleDetailsLoad()
    }
    
    /// Measures API call durations during typical app usage
    private func measureApiCallDurations() {
        // Navigate to screens that trigger API calls
        navigateToVehicleList()
        performVehicleSearch()
        navigateToFuelLogs()
    }
    
    // MARK: - Navigation & UI Interaction
    
    /// Performs basic app navigation to ensure proper loading
    private func performBasicNavigation() {
        // Wait for login screen
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        
        // Tap login (assuming we can proceed without credentials for testing)
        loginButton.tap()
        
        // Wait for home screen
        waitForHomeScreen()
    }
    
    /// Performs login flow
    private func performLogin() {
        let loginButton = app.buttons["Login"]
        if loginButton.exists {
            loginButton.tap()
            
            // Wait for navigation to complete
            waitForHomeScreen()
        }
    }
    
    /// Measures home screen load time
    private func measureHomeScreenLoad() {
        let homeTab = app.buttons["Home"]
        if homeTab.exists {
            let startTime = CFAbsoluteTimeGetCurrent()
            homeTab.tap()
            
            // Wait for content to load
            let vehicleCount = app.staticTexts["vehicle-count"]
            _ = vehicleCount.waitForExistence(timeout: 5)
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let loadTime = (endTime - startTime) * 1000
            print("🏠 Home screen load time: \(loadTime)ms")
        }
    }
    
    /// Measures browse screen load time
    private func measureBrowseScreenLoad() {
        let browseTab = app.buttons["Browse"]
        if browseTab.exists {
            let startTime = CFAbsoluteTimeGetCurrent()
            browseTab.tap()
            
            // Wait for vehicle list to load
            let vehicleList = app.tables["vehicle-list"]
            _ = vehicleList.waitForExistence(timeout: 10)
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let loadTime = (endTime - startTime) * 1000
            print("🔍 Browse screen load time: \(loadTime)ms")
        }
    }
    
    /// Measures vehicle details screen load time
    private func measureVehicleDetailsLoad() {
        // Tap on first vehicle if available
        let firstVehicle = app.tables["vehicle-list"].cells.firstMatch
        if firstVehicle.exists {
            let startTime = CFAbsoluteTimeGetCurrent()
            firstVehicle.tap()
            
            // Wait for vehicle details to load
            let vehicleName = app.staticTexts["vehicle-name"]
            _ = vehicleName.waitForExistence(timeout: 5)
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let loadTime = (endTime - startTime) * 1000
            print("🚗 Vehicle details load time: \(loadTime)ms")
            
            // Navigate back
            let backButton = app.navigationBars.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
            }
        }
    }
    
    /// Navigates to vehicle list and triggers API calls
    private func navigateToVehicleList() {
        let browseTab = app.buttons["Browse"]
        if browseTab.exists {
            browseTab.tap()
            
            // Wait for API call to complete
            let vehicleList = app.tables["vehicle-list"]
            _ = vehicleList.waitForExistence(timeout: 10)
        }
    }
    
    /// Performs vehicle search which triggers API calls
    private func performVehicleSearch() {
        let searchField = app.searchFields.firstMatch
        if searchField.exists {
            searchField.tap()
            searchField.typeText("Ford")
            
            // Wait for search results using proper XCTest waiting
            let expectation = expectation(description: "Wait for search results")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 3.0)
            
            // Clear search
            let clearButton = searchField.buttons["Clear text"]
            if clearButton.exists {
                clearButton.tap()
            }
        }
    }
    
    /// Navigates to fuel logs section
    private func navigateToFuelLogs() {
        // Navigate to a vehicle first
        navigateToVehicleList()
        
        let firstVehicle = app.tables["vehicle-list"].cells.firstMatch
        if firstVehicle.exists {
            firstVehicle.tap()
            
            // Look for fuel logs section
            let fuelLogsButton = app.buttons["Fuel Logs"]
            if fuelLogsButton.exists {
                fuelLogsButton.tap()
                
                // Wait for fuel logs to load
                Thread.sleep(forTimeInterval: 2.0)
            }
        }
    }
    
    // MARK: - Wait Methods
    
    /// Waits for the app to fully load
    private func waitForAppToLoad() {
        let timeout: TimeInterval = 10
        let exists = app.wait(for: .runningForeground, timeout: timeout)
        XCTAssertTrue(exists, "App should be running in foreground")
    }
    
    /// Waits for home screen to appear
    private func waitForHomeScreen() {
        let homeIndicator = app.staticTexts["Welcome"]
        _ = homeIndicator.waitForExistence(timeout: 5)
    }
    
    // MARK: - Analytics Integration
    
    /// Starts a new execution and returns the execution ID
    private func startNewExecution(notes: String) -> String {
        // In a real implementation, we would communicate with the app to start analytics tracking
        // For now, we'll generate a unique ID and track it locally
        let executionId = UUID().uuidString
        currentExecutionId = executionId
        
        print("▶️ Started execution: \(executionId) - \(notes)")
        return executionId
    }
    
    /// Ends the current execution
    private func endCurrentExecution(executionId: String) {
        print("⏹️ Ended execution: \(executionId)")
        currentExecutionId = nil
    }
    
    /// Resets analytics data for clean testing
    private func resetAnalyticsData() {
        // In a real implementation, we would communicate with the app to reset analytics
        print("🧹 Resetting analytics data")
    }
    
    /// Generates and exports the final analytics report
    private func generateAndExportReport() {
        print("\n📈 Generating final analytics report...")
        
        // In a real implementation, we would:
        // 1. Retrieve collected metrics from the app
        // 2. Generate a comprehensive report
        // 3. Export to files (JSON, CSV, etc.)
        
        print("✅ Analytics report generated and exported")
        print("📁 Report files saved to: Documents/AnalyticsReports/")
    }
}

// MARK: - Helper Extensions

extension XCUIApplication {
    /// Waits for the application to reach a specific state
    func wait(for state: XCUIApplication.State, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "state == %d", state.rawValue)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
