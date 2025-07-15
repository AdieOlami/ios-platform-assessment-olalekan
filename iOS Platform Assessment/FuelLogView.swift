import SwiftUI

struct FuelLogView: View {
    
    @State var fuelEntry: FuelEntry
    let vehicleId: Int
    
    var body: some View {
        Form {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    label(value: fuelEntry.milesPerGallon!.rounded(toDecimalPlaces: 2), unit: "MPG")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogMPG)
                    label(value: "\(fuelEntry.miles!.rounded(toDecimalPlaces: 2)) mi", unit: "TRIP")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogTrip)
                    label(value: "\(fuelEntry.odometer!) mi", unit: "ODOMETER")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogOdometer)
                    label(value: "$\(fuelEntry.dollarPerGallon!.rounded(toDecimalPlaces: 2))", unit: "PRICE/GALLON")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogPricePerGallon)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    label(value: "$\(fuelEntry.dollarPerMile!.rounded(toDecimalPlaces: 2))", unit: "COST/MI")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogCostPerMile)
                    label(value: "$\(fuelEntry.totalCost!.rounded(toDecimalPlaces: 2))", unit: "AMOUNT")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogAmount)
                    label(value: "\(fuelEntry.gallons!.rounded(toDecimalPlaces: 2))", unit: "GALLONS")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogGallons)
                    label(value: fuelEntry.fuelType ?? "-", unit: "FUEL TYPE")
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogView.fuelLogType)
                }
            }
        }
        .navigationTitle("Fuel Entry - \(fuelEntry.date!.formatted())")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func label(value: String, unit: String) -> some View {
        VStack(alignment:.leading, spacing: 2) {
            Text(unit)
                .foregroundColor(.gray)
                .font(.subheadline)
            Text(value)
                .bold()
        }
    }
}

#Preview {
    NavigationView {
        FuelLogView(fuelEntry: SampleData.fuelEntries[0], vehicleId: 1)
    }
}
