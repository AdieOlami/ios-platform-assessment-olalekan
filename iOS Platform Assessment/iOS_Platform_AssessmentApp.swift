import SwiftUI

@main
struct iOS_Platform_AssessmentApp: App {
    
    init() {
        PerformanceTracker.shared.startAppLaunch()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    PerformanceTracker.shared.completeAppLaunch()
                }
        }
    }
}
