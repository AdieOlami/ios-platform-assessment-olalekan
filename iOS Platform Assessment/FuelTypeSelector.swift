import SwiftUI

struct FuelTypeSelector: View {
    
    @Binding var selectedFuelType: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let fuelTypes: [String] = [
        "Gasoline",
        "Diesel",
        "Ethanol",
        "Methanol",
        "Propane",
        "Natural Gas",
        "Biodiesel",
        "Hydrogen",
        "Electric",
        "Liquefied Petroleum Gas",
        "Compressed Natural Gas",
        "Butane",
        "Coal",
        "Kerosene",
        "Jet Fuel",
        "Aviation Gasoline",
        "Alcohol",
        "Furnace Oil",
        "Heating Oil",
        "Naphtha",
        "Mogas",
        "Fuel Oil",
        "Biogas",
        "Wood Pellets",
        "Vegetable Oil",
        "Peat",
        "Charcoal",
        "Waste Oil",
        "Solar Power",
        "Geothermal Energy",
        "Turbine Fuel",
        "Rocket Fuel",
        "Battery Electric",
        "Flex Fuel",
        "Hydrocarbon Fuel",
        "Synthetic Fuel"
    ]
    
    
    var body: some View {
        List(fuelTypes, id: \.self) { item in
            HStack {
                Text(item)
                Spacer()
                if selectedFuelType == item {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedFuelType = item
            }
        }
        .navigationTitle("Select a fuel type")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
        })
    }
    
}
