import SwiftUI

struct FormDoubleField: View {
    
    var label: String
    @Binding var doubleValue: Double?
    
    var placeholder: String?
    var description: String?
    var required: Bool
    
    private var internalText: Binding<String> {
        Binding<String>(
            get: {
                if let value = doubleValue {
                    return value.formattedString
                }
                
                return ""
            },
            set: {
                
                let formatted = $0.replacingOccurrences(of: ",", with: "")
                
                guard let value = Double(formatted), !$0.isEmpty else {
                    self.doubleValue = nil
                    return
                }
                
                doubleValue = value
            })
    }
    
    init(label: String,
         value: Binding<Double?>,
         placeholder: String?,
         description: String? = nil,
         required: Bool = false) {
        self.label = label
        self._doubleValue = value
        self.placeholder = placeholder
        self.description = description
        self.required = required
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text(label)
                
                if required {
                    requiredField()
                }
            }
            
            TextField(placeholder ?? "", text: internalText)
                .keyboardType(.numberPad)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            if let description = description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .listRowInsets(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
    }
}
