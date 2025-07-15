import Foundation

struct FuelEntry {
    
    var id: Int?
    var vehicleId: Int?
    var date: Date?
    var odometer: Double?
    var gallons: Double?
    var price: Double?
    var totalCost: Double?
    var milesPerGallon: Double?
    var miles: Double?
    var dollarPerMile: Double?
    var dollarPerGallon: Double?
    var fuelType: String?
    
    init() {}
    
    init(
        id: Int,
        vehicleId: Int,
        date: Date,
        odometer: Double,
        gallons: Double,
        price: Double,
        totalCost: Double,
        milesPerGallon: Double,
        miles: Double,
        dollarPerMile: Double,
        dollarPerGallon: Double,
        fuelType: String
    ) {
        self.id = id
        self.vehicleId = vehicleId
        self.date = date
        self.odometer = odometer
        self.gallons = gallons
        self.price = price
        self.totalCost = totalCost
        self.milesPerGallon = milesPerGallon
        self.miles = miles
        self.dollarPerMile = dollarPerMile
        self.dollarPerGallon = dollarPerGallon
        self.fuelType = fuelType
    }
}

struct SampleData {
    
    static var vehicleList: [Vehicle] = [
        Vehicle(id: 1, name: "Tesla Model S", model: "Model S", year: "2022", make: "Tesla", status: "Active", location: "San Francisco", customName: "Elon's Ride"),
        Vehicle(id: 2, name: "Ford Mustang", model: "Mustang GT", year: "2021", make: "Ford", status: "Inactive", location: "Los Angeles", customName: "The Stallion"),
        Vehicle(id: 3, name: "Chevrolet Bolt", model: "Bolt EV", year: "2023", make: "Chevrolet", status: "Active", location: "New York", customName: "Electric Dream"),
        Vehicle(id: 4, name: "Toyota Camry", model: "Camry SE", year: "2020", make: "Toyota", status: "Inactive", location: "Chicago", customName: "Reliable Ride"),
        Vehicle(id: 5, name: "Honda Civic", model: "Civic LX", year: "2024", make: "Honda", status: "Active", location: "Houston", customName: "Speedy"),
        
        Vehicle(id: 6, name: "Ford F-150", model: "F-150", year: "2023", make: "Ford", status: "Active", location: "Dallas", customName: "The Workhorse"),
        Vehicle(id: 7, name: "Toyota RAV4", model: "RAV4", year: "2022", make: "Toyota", status: "Active", location: "Seattle", customName: "Adventure Mobile"),
        Vehicle(id: 8, name: "Honda CR-V", model: "CR-V", year: "2021", make: "Honda", status: "Active", location: "Boston", customName: "Urban Explorer"),
        Vehicle(id: 9, name: "Chevrolet Silverado", model: "Silverado 1500", year: "2023", make: "Chevrolet", status: "Active", location: "Denver", customName: "Mountain Mover"),
        Vehicle(id: 10, name: "Nissan Altima", model: "Altima", year: "2022", make: "Nissan", status: "Active", location: "Miami", customName: "Coastal Cruiser"),
        Vehicle(id: 11, name: "Hyundai Tucson", model: "Tucson", year: "2023", make: "Hyundai", status: "Active", location: "Portland", customName: "Green Machine"),
        Vehicle(id: 12, name: "Kia Sportage", model: "Sportage", year: "2022", make: "Kia", status: "Active", location: "Austin", customName: "Tech Trekker"),
        Vehicle(id: 13, name: "Volkswagen Tiguan", model: "Tiguan", year: "2023", make: "Volkswagen", status: "Active", location: "Philadelphia", customName: "City Slicker"),
        Vehicle(id: 14, name: "Mazda CX-5", model: "CX-5", year: "2022", make: "Mazda", status: "Active", location: "Atlanta", customName: "Zoom Zoom"),
        Vehicle(id: 15, name: "Subaru Outback", model: "Outback", year: "2023", make: "Subaru", status: "Active", location: "Minneapolis", customName: "Snow Warrior"),
        Vehicle(id: 16, name: "Jeep Grand Cherokee", model: "Grand Cherokee", year: "2022", make: "Jeep", status: "Active", location: "Phoenix", customName: "Desert Runner"),
        Vehicle(id: 17, name: "BMW X5", model: "X5", year: "2023", make: "BMW", status: "Active", location: "Washington DC", customName: "Executive Express"),
        Vehicle(id: 18, name: "Mercedes-Benz GLC", model: "GLC", year: "2022", make: "Mercedes-Benz", status: "Active", location: "Las Vegas", customName: "Luxury Liner"),
        Vehicle(id: 19, name: "Audi Q5", model: "Q5", year: "2023", make: "Audi", status: "Active", location: "San Diego", customName: "Tech Titan"),
        Vehicle(id: 20, name: "Lexus RX", model: "RX 350", year: "2022", make: "Lexus", status: "Active", location: "Nashville", customName: "Smooth Operator"),
        Vehicle(id: 21, name: "Ford Explorer", model: "Explorer", year: "2023", make: "Ford", status: "Active", location: "Charlotte", customName: "Adventure Seeker"),
        Vehicle(id: 22, name: "Toyota Highlander", model: "Highlander", year: "2022", make: "Toyota", status: "Active", location: "Orlando", customName: "Family First"),
        Vehicle(id: 23, name: "Honda Pilot", model: "Pilot", year: "2023", make: "Honda", status: "Active", location: "Detroit", customName: "Team Player"),
        Vehicle(id: 24, name: "Chevrolet Equinox", model: "Equinox", year: "2022", make: "Chevrolet", status: "Active", location: "St. Louis", customName: "Midwest Mover"),
        Vehicle(id: 25, name: "Nissan Rogue", model: "Rogue", year: "2023", make: "Nissan", status: "Active", location: "Cleveland", customName: "Urban Legend"),
        Vehicle(id: 26, name: "Hyundai Santa Fe", model: "Santa Fe", year: "2022", make: "Hyundai", status: "Active", location: "Pittsburgh", customName: "Steel City Cruiser"),
        Vehicle(id: 27, name: "Kia Sorento", model: "Sorento", year: "2023", make: "Kia", status: "Active", location: "Cincinnati", customName: "Queen City Rider"),
        Vehicle(id: 28, name: "Volkswagen Atlas", model: "Atlas", year: "2022", make: "Volkswagen", status: "Active", location: "Kansas City", customName: "Heartland Hero"),
        Vehicle(id: 29, name: "Mazda CX-9", model: "CX-9", year: "2023", make: "Mazda", status: "Active", location: "Indianapolis", customName: "Speedway Star"),
        Vehicle(id: 30, name: "Subaru Forester", model: "Forester", year: "2022", make: "Subaru", status: "Active", location: "Milwaukee", customName: "Brew City Beast"),
        Vehicle(id: 31, name: "Jeep Wrangler", model: "Wrangler", year: "2023", make: "Jeep", status: "Active", location: "Salt Lake City", customName: "Mountain Master"),
        Vehicle(id: 32, name: "BMW X3", model: "X3", year: "2022", make: "BMW", status: "Active", location: "New Orleans", customName: "Big Easy Rider"),
        Vehicle(id: 33, name: "Mercedes-Benz GLE", model: "GLE", year: "2023", make: "Mercedes-Benz", status: "Active", location: "Memphis", customName: "Blues Cruiser"),
        Vehicle(id: 34, name: "Audi Q7", model: "Q7", year: "2022", make: "Audi", status: "Active", location: "Louisville", customName: "Derby Day Driver"),
        Vehicle(id: 35, name: "Lexus NX", model: "NX 300", year: "2023", make: "Lexus", status: "Active", location: "Richmond", customName: "Capital Cruiser"),
        Vehicle(id: 36, name: "Ford Edge", model: "Edge", year: "2022", make: "Ford", status: "Active", location: "Hartford", customName: "Insurance Insider"),
        Vehicle(id: 37, name: "Toyota 4Runner", model: "4Runner", year: "2023", make: "Toyota", status: "Active", location: "Buffalo", customName: "Snow Buffalo"),
        Vehicle(id: 38, name: "Honda Ridgeline", model: "Ridgeline", year: "2022", make: "Honda", status: "Active", location: "Raleigh", customName: "Research Rover"),
        Vehicle(id: 39, name: "Chevrolet Traverse", model: "Traverse", year: "2023", make: "Chevrolet", status: "Active", location: "Jacksonville", customName: "River City Runner"),
        Vehicle(id: 40, name: "Nissan Pathfinder", model: "Pathfinder", year: "2022", make: "Nissan", status: "Active", location: "Tampa", customName: "Bay Breeze"),
        Vehicle(id: 41, name: "Hyundai Palisade", model: "Palisade", year: "2023", make: "Hyundai", status: "Active", location: "Sacramento", customName: "Capital Cruiser"),
        Vehicle(id: 42, name: "Kia Telluride", model: "Telluride", year: "2022", make: "Kia", status: "Active", location: "Columbus", customName: "Buckeye Beast"),
        Vehicle(id: 43, name: "Volkswagen ID.4", model: "ID.4", year: "2023", make: "Volkswagen", status: "Active", location: "Baltimore", customName: "Harbor Hero"),
        Vehicle(id: 44, name: "Mazda MX-30", model: "MX-30", year: "2022", make: "Mazda", status: "Active", location: "Providence", customName: "Ocean State Oasis"),
        Vehicle(id: 45, name: "Subaru Ascent", model: "Ascent", year: "2023", make: "Subaru", status: "Active", location: "Albuquerque", customName: "Desert Dreamer"),
        Vehicle(id: 46, name: "Jeep Cherokee", model: "Cherokee", year: "2022", make: "Jeep", status: "Active", location: "Omaha", customName: "Cornhusker Cruiser"),
        Vehicle(id: 47, name: "BMW iX", model: "iX", year: "2023", make: "BMW", status: "Active", location: "Tulsa", customName: "Oil Baron"),
        Vehicle(id: 48, name: "Mercedes-Benz EQS", model: "EQS", year: "2022", make: "Mercedes-Benz", status: "Active", location: "Fresno", customName: "Valley Voyager"),
        Vehicle(id: 49, name: "Audi e-tron", model: "e-tron", year: "2023", make: "Audi", status: "Active", location: "Birmingham", customName: "Iron City Icon"),
        Vehicle(id: 50, name: "Lexus RZ", model: "RZ 450e", year: "2022", make: "Lexus", status: "Active", location: "Rochester", customName: "Flower City Flyer"),
        Vehicle(id: 51, name: "Ford Bronco", model: "Bronco", year: "2023", make: "Ford", status: "Active", location: "Madison", customName: "Badger Beast"),
        Vehicle(id: 52, name: "Toyota Tundra", model: "Tundra", year: "2022", make: "Toyota", status: "Active", location: "Des Moines", customName: "Hawkeye Hauler"),
        Vehicle(id: 53, name: "Honda HR-V", model: "HR-V", year: "2023", make: "Honda", status: "Active", location: "Little Rock", customName: "Natural State Navigator"),
        Vehicle(id: 54, name: "Chevrolet Blazer", model: "Blazer", year: "2022", make: "Chevrolet", status: "Active", location: "Boise", customName: "Potato State Pioneer"),
        Vehicle(id: 55, name: "Nissan Murano", model: "Murano", year: "2023", make: "Nissan", status: "Active", location: "Spokane", customName: "Lilac City Liner"),
        Vehicle(id: 56, name: "Hyundai Kona", model: "Kona", year: "2022", make: "Hyundai", status: "Active", location: "Anchorage", customName: "Last Frontier Leader"),
        Vehicle(id: 57, name: "Kia EV6", model: "EV6", year: "2023", make: "Kia", status: "Active", location: "Honolulu", customName: "Aloha Adventurer"),
        Vehicle(id: 58, name: "Volkswagen Taos", model: "Taos", year: "2022", make: "Volkswagen", status: "Active", location: "Burlington", customName: "Green Mountain Glider"),
        Vehicle(id: 59, name: "Mazda CX-30", model: "CX-30", year: "2023", make: "Mazda", status: "Active", location: "Montgomery", customName: "Capitol City Cruiser"),
        Vehicle(id: 60, name: "Subaru Crosstrek", model: "Crosstrek", year: "2022", make: "Subaru", status: "Active", location: "Jackson", customName: "Magnolia State Mover"),
        Vehicle(id: 61, name: "Jeep Compass", model: "Compass", year: "2023", make: "Jeep", status: "Active", location: "Columbia", customName: "Palmetto State Pioneer"),
        Vehicle(id: 62, name: "BMW i4", model: "i4", year: "2022", make: "BMW", status: "Active", location: "Pierre", customName: "Mount Rushmore Mover"),
        Vehicle(id: 63, name: "Mercedes-Benz EQB", model: "EQB", year: "2023", make: "Mercedes-Benz", status: "Active", location: "Salem", customName: "Beaver State Beast"),
        Vehicle(id: 64, name: "Audi Q4 e-tron", model: "Q4 e-tron", year: "2022", make: "Audi", status: "Active", location: "Augusta", customName: "Pine Tree Pioneer"),
        Vehicle(id: 65, name: "Lexus UX", model: "UX 250h", year: "2023", make: "Lexus", status: "Active", location: "Concord", customName: "Granite State Glider"),
        Vehicle(id: 66, name: "Ford Escape", model: "Escape", year: "2022", make: "Ford", status: "Active", location: "Dover", customName: "First State Flyer"),
        Vehicle(id: 67, name: "Toyota Venza", model: "Venza", year: "2023", make: "Toyota", status: "Active", location: "Montpelier", customName: "Green Mountain Glider"),
        Vehicle(id: 68, name: "Honda Passport", model: "Passport", year: "2022", make: "Honda", status: "Active", location: "Carson City", customName: "Silver State Star"),
        Vehicle(id: 69, name: "Chevrolet Malibu", model: "Malibu", year: "2023", make: "Chevrolet", status: "Active", location: "Helena", customName: "Treasure State Traveler"),
        Vehicle(id: 70, name: "Nissan Kicks", model: "Kicks", year: "2022", make: "Nissan", status: "Active", location: "Cheyenne", customName: "Cowboy State Cruiser"),
        Vehicle(id: 71, name: "Hyundai Venue", model: "Venue", year: "2023", make: "Hyundai", status: "Active", location: "Juneau", customName: "Last Frontier Leader"),
        Vehicle(id: 72, name: "Kia Soul", model: "Soul", year: "2022", make: "Kia", status: "Active", location: "Santa Fe", customName: "Land of Enchantment Explorer"),
        Vehicle(id: 73, name: "Volkswagen Jetta", model: "Jetta", year: "2023", make: "Volkswagen", status: "Active", location: "Bismarck", customName: "Peace Garden Pioneer"),
        Vehicle(id: 74, name: "Mazda3", model: "Mazda3", year: "2022", make: "Mazda", status: "Active", location: "Olympia", customName: "Evergreen State Explorer"),
        Vehicle(id: 75, name: "Subaru Impreza", model: "Impreza", year: "2023", make: "Subaru", status: "Active", location: "Topeka", customName: "Sunflower State Star"),
        Vehicle(id: 76, name: "Jeep Renegade", model: "Renegade", year: "2022", make: "Jeep", status: "Active", location: "Frankfort", customName: "Bluegrass State Beast"),
        Vehicle(id: 77, name: "BMW 3 Series", model: "330i", year: "2023", make: "BMW", status: "Active", location: "Baton Rouge", customName: "Bayou State Beast"),
        Vehicle(id: 78, name: "Mercedes-Benz C-Class", model: "C300", year: "2022", make: "Mercedes-Benz", status: "Active", location: "Annapolis", customName: "Old Line State Oasis"),
        Vehicle(id: 79, name: "Audi A4", model: "A4", year: "2023", make: "Audi", status: "Active", location: "Lansing", customName: "Great Lakes Glider"),
        Vehicle(id: 80, name: "Lexus ES", model: "ES 350", year: "2022", make: "Lexus", status: "Active", location: "Jefferson City", customName: "Show Me State Star"),
        Vehicle(id: 81, name: "Ford Fusion", model: "Fusion", year: "2023", make: "Ford", status: "Active", location: "Lincoln", customName: "Cornhusker Cruiser"),
        Vehicle(id: 82, name: "Toyota Avalon", model: "Avalon", year: "2022", make: "Toyota", status: "Active", location: "Carson City", customName: "Silver State Star"),
        Vehicle(id: 83, name: "Honda Accord", model: "Accord", year: "2023", make: "Honda", status: "Active", location: "Concord", customName: "Granite State Glider"),
        Vehicle(id: 84, name: "Chevrolet Impala", model: "Impala", year: "2022", make: "Chevrolet", status: "Active", location: "Trenton", customName: "Garden State Glider"),
        Vehicle(id: 85, name: "Nissan Maxima", model: "Maxima", year: "2023", make: "Nissan", status: "Active", location: "Santa Fe", customName: "Land of Enchantment Leader"),
        Vehicle(id: 86, name: "Hyundai Sonata", model: "Sonata", year: "2022", make: "Hyundai", status: "Active", location: "Albany", customName: "Empire State Explorer"),
        Vehicle(id: 87, name: "Kia K5", model: "K5", year: "2023", make: "Kia", status: "Active", location: "Raleigh", customName: "Tar Heel Traveler"),
        Vehicle(id: 88, name: "Volkswagen Passat", model: "Passat", year: "2022", make: "Volkswagen", status: "Active", location: "Columbus", customName: "Buckeye Beast"),
        Vehicle(id: 89, name: "Mazda6", model: "Mazda6", year: "2023", make: "Mazda", status: "Active", location: "Salem", customName: "Beaver State Beast"),
        Vehicle(id: 90, name: "Subaru Legacy", model: "Legacy", year: "2022", make: "Subaru", status: "Active", location: "Harrisburg", customName: "Keystone State Cruiser"),
        Vehicle(id: 91, name: "Jeep Gladiator", model: "Gladiator", year: "2023", make: "Jeep", status: "Active", location: "Providence", customName: "Ocean State Oasis"),
        Vehicle(id: 92, name: "BMW 5 Series", model: "530i", year: "2022", make: "BMW", status: "Active", location: "Columbia", customName: "Palmetto State Pioneer"),
        Vehicle(id: 93, name: "Mercedes-Benz E-Class", model: "E350", year: "2023", make: "Mercedes-Benz", status: "Active", location: "Pierre", customName: "Mount Rushmore Mover"),
        Vehicle(id: 94, name: "Audi A6", model: "A6", year: "2022", make: "Audi", status: "Active", location: "Montpelier", customName: "Green Mountain Glider"),
        Vehicle(id: 95, name: "Lexus IS", model: "IS 300", year: "2023", make: "Lexus", status: "Active", location: "Charleston", customName: "Mountain State Mover"),
        Vehicle(id: 96, name: "Ford Taurus", model: "Taurus", year: "2022", make: "Ford", status: "Active", location: "Dover", customName: "First State Flyer"),
        Vehicle(id: 97, name: "Toyota Crown", model: "Crown", year: "2023", make: "Toyota", status: "Active", location: "Topeka", customName: "Sunflower State Star"),
        Vehicle(id: 98, name: "Honda Insight", model: "Insight", year: "2022", make: "Honda", status: "Active", location: "Frankfort", customName: "Bluegrass State Beast"),
        Vehicle(id: 99, name: "Chevrolet Corvette", model: "Corvette", year: "2023", make: "Chevrolet", status: "Active", location: "Baton Rouge", customName: "Bayou State Beast"),
        Vehicle(id: 100, name: "Nissan GT-R", model: "GT-R", year: "2022", make: "Nissan", status: "Active", location: "Annapolis", customName: "Old Line State Oasis")
    ]
    
    private static func generateRandomFuelEntries() -> [FuelEntry] {
        var entries: [FuelEntry] = []
        let baseDate = Date()
        let calendar = Calendar.current
        
        // Fuel types to randomly select from
        let fuelTypes = ["Gasoline", "Diesel", "Electric", "Hybrid", "Premium"]
        
        // Generate 995 random entries
        for id in 6...1000 {
            // Random vehicleId between 1 and 100
            let vehicleId = Int.random(in: 6...100)
            
            // Random date within last 2 years
            let daysAgo = Int.random(in: 1...730)
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: baseDate)!
            
            // Generate realistic odometer reading (between 1000 and 150000)
            let odometer = Double.random(in: 1000...150000)
            
            // Generate realistic gallons (between 5 and 30)
            let gallons = Double.random(in: 5...30)
            
            // Generate realistic price per gallon (between 2.50 and 5.00)
            let pricePerGallon = Double.random(in: 2.50...5.00)
            let totalCost = gallons * pricePerGallon
            
            // Calculate realistic MPG (between 15 and 45)
            let milesPerGallon = Double.random(in: 15...45)
            let miles = gallons * milesPerGallon
            
            let dollarPerMile = totalCost / miles
            
            // Random fuel type
            let fuelType = fuelTypes[Int.random(in: 0..<fuelTypes.count)]
            
            let entry = FuelEntry(
                id: id,
                vehicleId: vehicleId,
                date: date,
                odometer: odometer.rounded(toPlaces: 1),
                gallons: gallons.rounded(toPlaces: 1),
                price: pricePerGallon.rounded(toPlaces: 2),
                totalCost: totalCost.rounded(toPlaces: 2),
                milesPerGallon: milesPerGallon.rounded(toPlaces: 1),
                miles: miles.rounded(toPlaces: 1),
                dollarPerMile: dollarPerMile.rounded(toPlaces: 3),
                dollarPerGallon: pricePerGallon.rounded(toPlaces: 2),
                fuelType: fuelType
            )
            
            entries.append(entry)
        }
        
        return entries
    }
    
    static var fuelEntries: [FuelEntry] = {
        // Start with existing 5 entries
        var entries = [
            FuelEntry(
                id: 1,
                vehicleId: 1,
                date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 365 * 1),
                odometer: 1200,
                gallons: 12.5,
                price: 37.5,
                totalCost: 37.5,
                milesPerGallon: 30.0,
                miles: 375.0,
                dollarPerMile: 0.1,
                dollarPerGallon: 3.0,
                fuelType: "Gasoline"
            ),
            FuelEntry(
                id: 2,
                vehicleId: 1,
                date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 180 * 1),
                odometer: 1500,
                gallons: 15.0,
                price: 45.0,
                totalCost: 45.0,
                milesPerGallon: 30.0,
                miles: 450.0,
                dollarPerMile: 0.1,
                dollarPerGallon: 3.0,
                fuelType: "Diesel"
            ),
            FuelEntry(
                id: 3,
                vehicleId: 2,
                date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 90 * 1),
                odometer: 1800,
                gallons: 18.0,
                price: 54.0,
                totalCost: 54.0,
                milesPerGallon: 30.0,
                miles: 540.0,
                dollarPerMile: 0.1,
                dollarPerGallon: 3.0,
                fuelType: "Jet Fuel"
            ),
            FuelEntry(
                id: 4,
                vehicleId: 2,
                date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 60 * 1),
                odometer: 2100,
                gallons: 21.0,
                price: 63.0,
                totalCost: 63.0,
                milesPerGallon: 30.0,
                miles: 630.0,
                dollarPerMile: 0.1,
                dollarPerGallon: 3.0,
                fuelType: "Gasoline"
            ),
            FuelEntry(
                id: 5,
                vehicleId: 3,
                date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 30 * 1),
                odometer: 2400,
                gallons: 24.0,
                price: 72.0,
                totalCost: 72.0,
                milesPerGallon: 30.0,
                miles: 720.0,
                dollarPerMile: 0.1,
                dollarPerGallon: 3.0,
                fuelType: "Diesel"
            )
        ]
        
        // Add 995 random entries
        entries.append(contentsOf: generateRandomFuelEntries())
        return entries
    }()
}

// Extension to round doubles to specified decimal places
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
