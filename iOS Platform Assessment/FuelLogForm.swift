import SwiftUI

struct FuelLogForm: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var fuelEntry: FuelEntry
    @State var discount: Double?
    @State var total: Double?
    
    let vehicleId: Int
    
    init(vehicleId: Int) {
        var initial = FuelEntry()
        initial.date = Date()
        self._fuelEntry = .init(initialValue: initial)
        self.vehicleId = vehicleId
    }
    
    var body: some View {
        VStack {
            
            if validationMessage.count > 0 {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                            validationMessage = ""
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.validationMessage)
            }
            
            Form  {
                FormDateField(
                    label: "Date",
                    date: Binding(
                        get: { fuelEntry.date },
                        set: {
                            fuelEntry.date = $0
                        }),
                    required: true)
                .padding(.vertical)
                .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogDate)
                
                FormDoubleField(
                    label: "Price/Gallon ($)",
                    value: Binding(
                        get: { fuelEntry.dollarPerGallon },
                        set: {
                            fuelEntry.dollarPerGallon = $0
                            total = ($0 ?? 0) * (fuelEntry.gallons ?? 0)
                        }),
                    placeholder: "0.00",
                    required: true)
                .padding(.vertical)
                .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogPricePerGallon)
                
                FormDoubleField(
                    label: "Gallons",
                    value: Binding(
                        get: { fuelEntry.gallons },
                        set: {
                            fuelEntry.gallons = $0
                            total = ($0 ?? 0) * (fuelEntry.dollarPerGallon ?? 0)
                        }),
                    placeholder: "0.00")
                .padding(.vertical)
                .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogGallons)
                
                FormDoubleField(
                    label: "Total",
                    value: $total,
                    placeholder: "0.00",
                    description: "Automatically Calculated")
                .disabled(true)
                .padding(.vertical)
                .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogTotalCost)
                
                FormDoubleField(
                    label: "Trip Miles",
                    value: $fuelEntry.miles,
                    placeholder: "0 mi",
                    required: true)
                .padding(.vertical)
                .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogTotalMilage)
                
                FormDoubleField(
                    label: "Odometer",
                    value: $fuelEntry.odometer,
                    placeholder: "0 mi",
                    required: true)
                .padding(.vertical)
                .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogOdometer)
                
                Section {
                    NavigationLink(destination: FuelTypeSelector(selectedFuelType: $fuelEntry.fuelType)
                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogTypeSelector)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Fuel Type")
                                        .foregroundColor(.gray)
                                    
                                    Text("*")
                                        .foregroundColor(.red)
                                }
                                
                                if let fuelType = fuelEntry.fuelType, !fuelType.isEmpty {
                                    Text(fuelType)
                                        .accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.fuelLogFuelType)
                                }
                            }
                        }
                }
            }
        }
        .navigationTitle("New Fuel Entry")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button("Save") {
                fuelEntry.totalCost = total
                fuelEntry.vehicleId = vehicleId
                fuelEntry.id = SampleData.fuelEntries.count + 1
                
                if let miles = fuelEntry.miles, let gallons = fuelEntry.gallons {
                    fuelEntry.milesPerGallon = miles / gallons
                }
                
                if let gallons = fuelEntry.gallons, let dollarPerGallon = fuelEntry.dollarPerGallon {
                    fuelEntry.dollarPerMile = dollarPerGallon / gallons
                }
                
                if validateEntry() {
                    SampleData.fuelEntries.append(fuelEntry)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    showValidationMessage()
                }
            }.accessibilityIdentifier(AccessibilityIdentifiers.FuelLogForm.saveButton))
    }
    
    func validateEntry() -> Bool {
        return fuelEntry.date != nil
        && fuelEntry.dollarPerGallon != nil
        && fuelEntry.gallons != nil
        && fuelEntry.odometer != nil
        && fuelEntry.fuelType != nil
        && fuelEntry.miles != nil
    }
    
    @State var validationMessage = ""
    
    func showValidationMessage() {
        if !validateEntry() {
            validationMessage = "Please complete all required fields"
        } else {
            validationMessage = ""
        }
    }
}


#Preview {
    NavigationView {
        FuelLogForm(vehicleId: 1)
    }
}
