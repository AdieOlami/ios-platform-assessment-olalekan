//
//  VehicleApiRouter.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - VehicleApiRouter

enum VehicleApiRouter {
    case vehicleList
}

// MARK: - BaseRequest

extension VehicleApiRouter: BaseRequest {
    
    var baseUrl: String {
        BASE_URL
    }
    
    var path: String {
        switch self {
        case .vehicleList:
            "vehicles/"
        }
    }
    
    var headers: HTTPHeaders {
        [:]
    }
    
    var method: HTTPRequestMethod {
        .get
    }
    
    var parameters: HTTPParameters {
        nil
    }
}
