import Foundation

struct AccessibilityIdentifiers {
    
    struct HomeView {
        static let homeTab = "home_tab"
        static let browseTab = "browse_tab"
        static let notificationsTab = "notifications_tab"
        static let searchTab = "search_tab"
    }
    
    struct SearchBar {
        static let searchTextField = "search_text_field"
    }
    
    struct LoginView {
        static let accountTokenTextField = "account_token_text_field"
        static let apiKeyTextField = "api_key_text_field"
        static let loginButton = "login_button"
    }
    
    struct BrowseView {
        static let browseList = "browse_list"
        
        static func browseListItem(type: String) -> String {
            return "browse_list_item_\(type)"
        }
    }
    
    struct FleetioLogo {
        static let fleetioLogo = "fleetio_logo"
    }
    
    struct RootView {
        static let rootView = "root_view"
    }
    
    struct TabBar {
        static let tabBar = "tab_bar"
    }
    
    struct TabBarItem {
        static let homeTabBarItem = "home_tab_bar_item"
        static let browseTabBarItem = "browse_tab_bar_item"
        static let notificationsTabBarItem = "notifications_tab_bar_item"
        static let searchTabBarItem = "search_tab_bar_item"
    }
    
    struct VehicleList {
        static let vehicleList = "vehicle_list"
        
        static func vehicleListItem(id: Int) -> String {
            return "vehicle_list_item_\(id)"
        }
    }
    
    struct VehicleView {
        static let vehicleView = "vehicle_view"
        
        static func vehicleOption(name: String) -> String {
            return "vehicle_option_\(name)"
        }
    }
    
    struct FuelLogList {
        static let fuelLogList = "fuel_log_list"
        
        static let newFuelEntry = "fuel_log_new_entry"
        
        static func fuelLogListItem(id: Int) -> String {
            return "fuel_log_list_item_\(id)"
        }
    }
    
    struct FuelLogForm {
        
        static let fuelLogForm = "fuel_log_form"
        static let fuelLogDate = "fuel_log_date"
        static let fuelLogOdometer = "fuel_log_odometer"
        static let fuelLogGallons = "fuel_log_gallons"
        static let fuelLogFuelType = "fuel_log_fuel_type"
        static let fuelLogTotalCost = "fuel_log_total_cost"
        static let fuelLogPricePerGallon = "fuel_log_price_per_gallon"
        static let fuelLogTotalMilage = "fuel_log_total_milage"
        static let saveButton = "fuel_log_save"
        static let fuelLogTypeSelector = "fuel_log_type_selector"
        static let validationMessage = "validation_message"
    }
    
    struct FuelLogView {
        static let fuelLogView = "fuel_log_view"
        static let fuelLogMPG = "fuel_log_mpg"
        static let fuelLogTrip = "fuel_log_trip"
        static let fuelLogOdometer = "fuel_log_odometer"
        static let fuelLogPricePerGallon = "fuel_log_price_per_gallon"
        static let fuelLogCostPerMile = "fuel_log_cost_per_mile"
        static let fuelLogAmount = "fuel_log_amount"
        static let fuelLogGallons = "fuel_log_gallons"
        static let fuelLogType = "fuel_log_type"
    }
}
