# Analytics Collection System

## Overview

This analytics collection system measures key performance metrics for the iOS Platform Assessment app, including app start time, page load time, and API call duration.

## Architecture

### Core Components

#### 1. **AnalyticsEvent** (`AnalyticsEvent.swift`)

- Represents individual analytics events with metadata
- Supports different categories: performance, user interaction, navigation, API, error
- Includes structured data for API metrics, page metrics, and performance metrics

#### 2. **AnalyticsProvider** (`AnalyticsProvider.swift`)

- Singleton service that collects and manages analytics events
- Features:
  - Thread-safe event collection using dispatch queues
  - Automatic batching and flushing (50 events or 30 seconds)
  - Local storage for offline capability
  - Extensible for remote analytics service integration

#### 3. **PerformanceTracker** (`PerformanceTracker.swift`)

- Specialized tracker for performance metrics
- Provides convenient APIs for:
  - App launch time tracking
  - Page load time tracking
  - API call duration tracking
  - View render time tracking
  - Search response time tracking

#### 4. **View Extensions** (`View+Analytics.swift`)

- SwiftUI modifiers for easy integration
- Automatic view appearance/disappearance tracking
- Button tap tracking
- Navigation event tracking

#### 5. **AnalyticsDashboard** (`AnalyticsDashboard.swift`)

- Real-time dashboard for viewing collected metrics
- Displays:
  - Performance metrics summary
  - API performance and success rates
  - Recent events
  - Data management controls

## Key Metrics Tracked

### 📱 **App Start Time**

- **Cold Start**: First app launch
- **Warm Start**: Subsequent launches
- Includes device metadata (model, OS version)

```swift
// Automatic tracking in iOS_Platform_AssessmentApp.swift
PerformanceTracker.shared.startAppLaunch()
PerformanceTracker.shared.completeAppLaunch()
```

### 📄 **Page Load Time**

- Tracks individual view loading performance
- Measures from view instantiation to content display
- Includes source page information

```swift
// Example usage
let tracker = PerformanceTracker.shared.startPageLoad(pageName: "VehicleList", source: "Browse")
// ... page loads ...
tracker.complete()
```

### 🌐 **API Call Duration**

- Tracks all network requests
- Includes endpoint, method, status codes, and error information
- Calculates success rates and average response times

```swift
// Integrated into VehicleService
let apiTracker = PerformanceTracker.shared.startAPICall(endpoint: "vehicles/", method: "GET")
// ... API call ...
apiTracker.complete(statusCode: 200)
```

### 🔍 **Additional Metrics**

- **Search Response Time**: Query performance and result counts
- **View Render Time**: UI rendering performance
- **User Interactions**: Button taps, navigation events
- **Error Tracking**: API failures and exceptions

## Integration Examples

### View Tracking

```swift
struct MyView: View {
    var body: some View {
        VStack {
            // View content
        }
        .trackViewAppearance(viewName: "MyView")
    }
}
```

### Button Tracking

```swift
Button("Save") {
    // Action
}
.trackTap(buttonName: "SaveButton", additionalProperties: ["form_type": "vehicle"])
```

### Navigation Tracking

```swift
NavigationLink(destination: DetailView()) {
    Text("Go to Detail")
}
.trackNavigation(destination: "DetailView", source: "ListView")
```

## Data Storage and Privacy

### Local Storage

- Events stored in UserDefaults for demonstration
- Production implementation should use Core Data or SQLite
- Automatic cleanup and data management

### Privacy Considerations

- No personally identifiable information (PII) collected
- Focus on performance and usage patterns
- Configurable data retention policies

## Performance Impact

### Optimizations

- **Asynchronous Processing**: All analytics operations are non-blocking
- **Batching**: Events are collected and sent in batches
- **Minimal Overhead**: < 1ms per event
- **Memory Efficient**: Automatic cleanup and size limits

### Background Processing

```swift
private let queue = DispatchQueue(label: "analytics.queue", qos: .utility)
```

## Dashboard Features

### Real-time Metrics

- App start time (cold/warm launches)
- Average page load times
- API success rates and response times
- Recent event timeline

### Data Management

- Manual flush controls
- Local data clearing

### Visual Analytics

- Color-coded event categories
- Performance trend indicators
- Interactive metric cards

## Usage in App

### Viewing Analytics

1. Launch the app
2. Navigate to the "Analytics" tab
3. View real-time performance metrics
4. Use "Flush Events" to immediately process queued data

### Automatic Tracking

The system automatically tracks:

- ✅ App launch time
- ✅ Page transitions (VehicleList, HomeView, etc.)
- ✅ API calls to vehicle service
- ✅ Search interactions
- ✅ Button taps and navigation events

## Extension Points

### Adding New Metrics

```swift
// Define new metric
enum CustomMetric: String {
    case customAction = "custom_action"
}

// Track custom event
AnalyticsProvider.shared.track(
    metric: .customAction,
    duration: actionDuration,
    properties: ["context": "user_action"]
)
```

### Remote Analytics Integration

```swift
private func sendToRemoteAnalyticsService(_ events: [AnalyticsEvent]) {
    // Integrate with Firebase Analytics, Mixpanel, etc.
    // POST events to analytics endpoint
}
```

## Testing Considerations

- Analytics is disabled during UI tests (`IS_UI_TESTING` environment variable)
- Separate test analytics provider for unit tests
- Mock tracking for consistent test behavior

## Future Enhancements

1. **Real-time Monitoring**: WebSocket-based/Firebase DB live analytics
2. **A/B Testing**: Feature flag integration
3. **Crash Reporting**: Integration with crash analytics
4. **Custom Events**: User-defined analytics events
5. **Data Export**: CSV/JSON export functionality
6. **Performance Alerts**: Threshold-based notifications
