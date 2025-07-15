import SwiftUI

extension View {
    
    
    @ViewBuilder
    /// Required Field. A red astrisk string.
    /// - Returns: Red astrisk indicating a requirement the user must input.
    func requiredField() -> some View {
        Text("*")
            .foregroundColor(.red)
    }
    
    @ViewBuilder
    /// Locked Field. A locked icon.
    /// - Returns: Lock icon for form field
    func lockedField() -> some View {
        Image(systemName: "lock")
            .resizable()
            .foregroundColor(.gray)
            .frame(width: 20, height: 20)
    }
}
