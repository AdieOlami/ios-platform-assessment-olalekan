#!/bin/bash

# iOS Platform Assessment - Analyti    # Check if fastlane is available (via bundle)
        # Run metrics collection via fastlane
    if bundle exec fastlane collect_metrics; then
        print_success "Fastlane metrics collection completed"
    else
        print_error "Fastlane metrics collection failed"
        return 1
    fi
    
    # Generate the analytics report
    if bundle exec fastlane analytics_report; then
        print_success "Analytics report generated via Fastlane"
    else
        print_warning "Analytics report generation failed, but metrics were collected"
    fiec fastlane --version &> /dev/null; then
        print_error "Fastlane is not available via bundle exec. Please ensure it's installed:"
        print_error "  bundle install"
        exit 1
    firics Collection Script
# This script automates the collection of performance metrics over 10 test executions
# and generates comprehensive analytics reports.

set -e  # Exit on any error

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$PROJECT_DIR/AnalyticsReports"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_NAME="analytics_report_${TIMESTAMP}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if we're in the right directory
    if [[ ! -f "iOS Platform Assessment.xcodeproj/project.pbxproj" ]]; then
        print_error "This script must be run from the root of the iOS Platform Assessment project"
        exit 1
    fi
    
    # Check if fastlane is available (via bundle)
    if ! bundle exec fastlane --version &> /dev/null; then
        print_error "Fastlane is not available via bundle exec. Please ensure it's installed:"
        print_error "  bundle install"
        exit 1
    fi
    
    # Check if xcodebuild is available
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode command line tools are not installed"
        exit 1
    fi
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    print_success "Prerequisites check passed"
}

# Function to run metrics collection via different methods
run_metrics_collection() {
    local method="$1"
    
    print_status "Starting metrics collection using method: $method"
    
    case "$method" in
        "fastlane")
            run_fastlane_metrics
            ;;
        "xcodebuild")
            run_xcodebuild_metrics
            ;;
        "direct")
            run_direct_metrics
            ;;
        *)
            print_error "Unknown method: $method"
            print_status "Available methods: fastlane, xcodebuild, direct"
            exit 1
            ;;
    esac
}

# Function to run metrics collection via Fastlane
run_fastlane_metrics() {
    print_status "Running analytics collection via Fastlane..."
    
    cd "$PROJECT_DIR"
    
    # Run the metrics collection lane
    if bundle exec fastlane collect_metrics; then
        print_success "Fastlane metrics collection completed"
    else
        print_error "Fastlane metrics collection failed"
        return 1
    fi
    
    # Generate the analytics report
    if bundle exec fastlane analytics_report; then
        print_success "Analytics report generated via Fastlane"
    else
        print_warning "Analytics report generation failed, but metrics were collected"
    fi
}

# Function to run metrics collection via xcodebuild
run_xcodebuild_metrics() {
    print_status "Running analytics collection via xcodebuild..."
    
    cd "$PROJECT_DIR"
    
    # Build the project first
    print_status "Building project..."
    xcodebuild -project "iOS Platform Assessment.xcodeproj" \
               -scheme "iOS Platform Assessment" \
               -destination "platform=iOS Simulator,name=iPhone 16 Pro,OS=18.0" \
               build
    
    # Run the metrics collection test
    print_status "Running metrics collection tests..."
    xcodebuild test \
               -project "iOS Platform Assessment.xcodeproj" \
               -scheme "iOS Platform Assessment" \
               -destination "platform=iOS Simulator,name=iPhone 16 Pro,OS=18.0" \
               -only-testing "iOS Platform AssessmentTests/MetricsCollectionTest/generateTenExecutionAnalyticsReport" \
               -resultBundlePath "$OUTPUT_DIR/TestResults_${TIMESTAMP}.xcresult"
    
    print_success "XcodeBuild metrics collection completed"
}

# Function to run direct metrics collection
run_direct_metrics() {
    print_status "Running direct metrics collection test..."
    
    cd "$PROJECT_DIR"
    
    # Run just the metrics collection test
    swift test --filter MetricsCollectionTest || {
        print_warning "Swift test command failed, falling back to xcodebuild"
        run_xcodebuild_metrics
    }
}

# Function to verify metrics collection
verify_metrics() {
    print_status "Verifying collected metrics..."
    
    # Check if analytics files were created
    local analytics_files=(
        "$OUTPUT_DIR"/*.json
        "$OUTPUT_DIR"/*.csv
    )
    
    local files_found=0
    for file in "${analytics_files[@]}"; do
        if [[ -f "$file" ]]; then
            files_found=$((files_found + 1))
            print_success "Found analytics file: $(basename "$file")"
        fi
    done
    
    if [[ $files_found -eq 0 ]]; then
        print_warning "No analytics files found in $OUTPUT_DIR"
        print_status "Checking for files in the project directory..."
        
        # Look for analytics files in the project directory
        find "$PROJECT_DIR" -name "*analytics*" -o -name "*metrics*" -type f -newer "$PROJECT_DIR" 2>/dev/null | head -10
    else
        print_success "Found $files_found analytics files"
    fi
}

# Function to display results
show_results() {
    print_status "Analytics Collection Results"
    echo "=================================="
    echo "Timestamp: $(date)"
    echo "Project Directory: $PROJECT_DIR"
    echo "Output Directory: $OUTPUT_DIR"
    echo ""
    
    if [[ -d "$OUTPUT_DIR" ]]; then
        local file_count=$(find "$OUTPUT_DIR" -type f | wc -l)
        print_status "Generated $file_count files in output directory:"
        ls -la "$OUTPUT_DIR" 2>/dev/null || print_warning "Output directory is empty"
    fi
    
    echo ""
    print_status "To view the analytics dashboard in the app:"
    echo "1. Build and run the iOS Platform Assessment app"
    echo "2. Navigate to Settings or Debug menu"
    echo "3. Tap 'Analytics Dashboard'"
    echo ""
    print_status "Report files are saved in: $OUTPUT_DIR"
}

# Function to show usage
show_usage() {
    echo "iOS Platform Assessment - Analytics Metrics Collection"
    echo ""
    echo "Usage: $0 [method]"
    echo ""
    echo "Methods:"
    echo "  fastlane    - Use Fastlane lanes for metrics collection (recommended)"
    echo "  xcodebuild  - Use xcodebuild directly with test targets"
    echo "  direct      - Run Swift tests directly"
    echo "  all         - Try all methods in sequence"
    echo ""
    echo "Examples:"
    echo "  $0                    # Use default method (fastlane)"
    echo "  $0 fastlane          # Use Fastlane explicitly"
    echo "  $0 xcodebuild        # Use xcodebuild directly"
    echo "  $0 all               # Try all methods"
    echo ""
    echo "Environment Variables:"
    echo "  OUTPUT_DIR           # Override output directory"
    echo "  SIMULATOR_NAME       # Specify iOS Simulator name"
    echo ""
}

# Main execution
main() {
    local method="${1:-fastlane}"
    
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_usage
        exit 0
    fi
    
    print_status "iOS Platform Assessment - Analytics Metrics Collection"
    print_status "Starting analytics collection with method: $method"
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Run metrics collection
    if [[ "$method" == "all" ]]; then
        print_status "Attempting all collection methods..."
        
        # Try fastlane first
        if run_metrics_collection "fastlane"; then
            print_success "Fastlane method succeeded"
        elif run_metrics_collection "xcodebuild"; then
            print_success "XcodeBuild method succeeded"
        elif run_metrics_collection "direct"; then
            print_success "Direct method succeeded"
        else
            print_error "All methods failed"
            exit 1
        fi
    else
        run_metrics_collection "$method"
    fi
    
    # Verify results
    verify_metrics
    
    # Show results
    show_results
    
    print_success "Analytics metrics collection completed!"
    print_status "Check the output directory for generated reports: $OUTPUT_DIR"
}

# Handle script interruption
trap 'print_error "Script interrupted"; exit 1' INT TERM

# Run main function with all arguments
main "$@"