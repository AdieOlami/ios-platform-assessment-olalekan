import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate the difference between the current date and the target date
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year) Yr. Ago"
        }
        
        if let month = components.month, month > 0 {
            return "\(month) Mo. Ago"
        }
        
        if let day = components.day, day > 0 {
            return "\(day) Day\(day > 1 ? "s" : "") Ago"
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour) Hr. Ago"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute) Min. Ago"
        }
        
        if let second = components.second, second > 0 {
            return "\(second) Sec. Ago"
        }
        
        return "Just Now"
    }
}
