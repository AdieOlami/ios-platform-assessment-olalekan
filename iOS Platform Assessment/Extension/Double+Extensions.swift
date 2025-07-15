import Foundation

extension Double {
    func rounded(toDecimalPlaces places: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if places == 0 {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = places
        }
        
        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString.replacingOccurrences(of: "(\\.\\d*?[1-9])0+$", with: "$1", options: .regularExpression)
                .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
        } else {
            return "\(self)"
        }
    }
    
    var formattedString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}
