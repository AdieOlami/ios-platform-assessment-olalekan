import Foundation
import SwiftUI

struct FormDateField: View {
    
    @Binding var nullableDate: Date?
    @Binding var minimumDate: Date?
    @Binding var maximumDate: Date?
    
    var label: String
    var displayedComponents: UIDatePicker.Mode
    var required: Bool
    var removable: Bool
    var locked: Bool
    var lockedTitle: String?
    var lockedMessage: String?
    var description: String?
    
    @State var showDatepicker: Bool
    @State var showLockedAlert: Bool = false
    @Binding var date: Date
    
    init(label: String,
         date: Binding<Date?>,
         description: String? = nil,
         displayedComponents: UIDatePicker.Mode = .dateAndTime,
         required: Bool = false,
         removable: Bool = true,
         locked: Bool = false,
         lockedTitle: String? = nil,
         lockedMessage: String? = nil,
         minimumDate: Binding<Date?>? = nil,
         maximumDate: Binding<Date?>? = nil) {
        
        self.label = label
        self._nullableDate = date
        self.displayedComponents = displayedComponents
        self.required = required
        self.removable = removable
        self.locked = locked
        self.lockedTitle = lockedTitle
        self.lockedMessage = lockedMessage
        self._minimumDate = minimumDate ?? .constant(nil)
        self._maximumDate = maximumDate ?? .constant(nil)
        
        self._showDatepicker = State(initialValue: date.wrappedValue != nil)
        self.description = description
        self._date = Binding(
            get: {
                if let date = date.wrappedValue {
                    return date
                }
                
                return Date()
            },
            set: {
                date.wrappedValue = $0
            })
    }
    
    @ViewBuilder func dateLabel() -> some View {
        if showDatepicker {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    if !required && !locked && removable {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                nullableDate = nil
                                showDatepicker = false
                            }
                    }
                    
                    DatePickerRepresentable(
                        selection: $date,
                        displayedComponents: displayedComponents,
                        minimumDate: _minimumDate,
                        maximumDate: _maximumDate)
                    .accentColor(.green)
                    .labelsHidden()
                    .frame(minHeight: 24)
                    .padding(.top, 4)
                    .disabled(locked)
                }
                if let description = description, description != "" {
                    Text(description)
                }
            }
            
        } else {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    if !locked {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .frame(width: 20, height: 20)
                    }
                    Text("Add Date")
                        .frame(minHeight: 24)
                }
                if let description = description, description != "" {
                    Text(description)
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Text(label)
                        .labelsHidden()
                    if required {
                        requiredField()
                    }
                    if locked {
                        lockedField()
                    }
                }
                
                ZStack(alignment: .topLeading) {
                    HStack(alignment: nullableDate == nil ? .top : .center, spacing: 18) {
                        dateLabel()
                        Spacer()
                    }
                    .zIndex(nullableDate == nil ? -1 : 1)
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if locked {
                                showLockedAlert = true
                            } else {
                                if nullableDate == nil {
                                    nullableDate = Date()
                                }
                                
                                showDatepicker = true
                            }
                        }
                }
            }
        }
        .alert(isPresented: $showLockedAlert) {
            Alert(title: Text(lockedTitle ?? ""), message: Text(lockedMessage ?? ""))
        }
        .listRowInsets(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
    }
}

struct DatePickerRepresentable: UIViewRepresentable {
    
    @Binding var selection: Date
    var displayedComponents: UIDatePicker.Mode
    @Binding var minimumDate: Date?
    @Binding var maximumDate: Date?
    
    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = displayedComponents
        
        if let minimumDate = minimumDate {
            datePicker.minimumDate = minimumDate
        }
        
        if let maximumDate = maximumDate {
            datePicker.maximumDate = maximumDate
        }
        
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }
    
    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
        datePicker.date = selection
        
        if let minimumDate = minimumDate {
            datePicker.minimumDate = minimumDate
        }
        
        if let maximumDate = maximumDate {
            datePicker.maximumDate = maximumDate
        }
    }
    
    func makeCoordinator() -> DatePickerRepresentable.Coordinator {
        Coordinator(date: $selection)
    }
    
    class Coordinator: NSObject {
        
        private let date: Binding<Date>
        
        init(date: Binding<Date>) {
            self.date = date
        }
        
        @objc func changed(_ sender: UIDatePicker) {
            self.date.wrappedValue = sender.date
        }
    }
}
