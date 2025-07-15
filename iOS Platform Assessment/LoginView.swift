import Foundation
import SwiftUI

struct LoginView: View {
    
    @State private var accountToken = ""
    @State private var apiKey = ""
    @State private var showError = false
    @State private var isLoggedIn = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("fleetio-logo")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                TextField("Account Token", text: $accountToken)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .accessibilityIdentifier(AccessibilityIdentifiers.LoginView.accountTokenTextField)
                
                SecureField("Api Key", text: $apiKey)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .accessibilityIdentifier(AccessibilityIdentifiers.LoginView.apiKeyTextField)
                
                if showError {
                    Text("Invalid account token or api key. Please try again.")
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isLoading {
                    ProgressView("Logging in...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Button(action: {
                        if validateLogin() {
                            isLoading = true
                            showError = false
                            // Simulate a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                isLoggedIn = true
                                isLoading = false
                            }
                        } else {
                            showError = true
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                    }
                    .padding()
                    .accessibilityIdentifier(AccessibilityIdentifiers.LoginView.loginButton)
                }
                
                NavigationLink(
                    destination: HomeView(),
                    isActive: $isLoggedIn,
                    label: { EmptyView() }
                )
            }
            .padding()
        }
    }
    
    func validateLogin() -> Bool {
        return !accountToken.isEmpty && !apiKey.isEmpty
    }
}

#Preview {
    LoginView()
}

