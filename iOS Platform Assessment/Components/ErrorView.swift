//
//  ErrorView.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import SwiftUI

// MARK: - ErrorView

struct ErrorView: View {
    
    // MARK: Lifecycle
    
    init(error: Error? = nil, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }
    
    // MARK: Internal
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack {
                    if let error = error as? APIError {
                        if case let .server(description) = error {
                            Text(description.detail)
                        } else {
                            Text(error.localizedDescription)
                        }
                    } else {
                        Text("An unexpected error occurred. Please try again.")
                    }
                }
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            
            if let retryAction = retryAction {
                Button("Try Again") {
                    retryAction()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    // MARK: Private
    
    private let error: Error?
    private let retryAction: (() -> Void)?
}

// MARK: - Preview

#Preview("Default Error") {
    ErrorView()
}

#Preview("With Error Message") {
    ErrorView(error: NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"]))
}

#Preview("With Retry Action") {
    ErrorView(error: NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error occurred"]), retryAction: {})
}
