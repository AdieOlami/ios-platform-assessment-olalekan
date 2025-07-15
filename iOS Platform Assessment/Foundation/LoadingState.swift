//
//  LoadingState.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - LoadingState

enum LoadingState<C, E>: Equatable where C: Equatable, E: Error & Equatable {
    case loading
    case loaded(C)
    case error(E)
}

extension LoadingState {
    
    // MARK: Public
    
    var data: C? {
        switch self {
        case .loaded(let data):
            return data
        case .error, .loading:
            return nil
        }
    }

    var error: E? {
        switch self {
        case .error(let error):
            return error
        case .loaded, .loading:
            return nil
        }
    }

    var isError: Bool {
        switch self {
        case .error:
            return true
        case .loading, .loaded:
            return false
        }
    }
    
    var isLoaded: Bool {
        switch self {
        case .loading, .error:
            return false
        case .loaded:
            return true
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loaded, .error:
            return false
        case .loading:
            return true
        }
    }
}

// MARK: - LoadingStateError

public enum LoadingStateError: Error, Equatable {
    case unableToLoadData
}
