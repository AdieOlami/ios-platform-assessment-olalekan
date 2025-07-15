//
//  NSError+Ext.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - NSError

extension NSError {
    
    convenience init(_ localizedDescriprion: String) {
        self.init(domain: "com.feetio.network", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescriprion])
    }
    
    var serverError: ServerError? {
        guard
            domain == HTTPErrorDomains.server,
            let errorBody = userInfo[RequestPerformerKeys.errorBodyKey] as? String
        else {
            return nil
        }
        return ServerError(statusCode: code, body: errorBody)
    }
    
    static func decodingError(with statusCode: Int) -> NSError {
        return NSError(
            domain: HTTPErrorDomains.decoding,
            code: statusCode,
            userInfo: [RequestPerformerKeys.errorBodyKey: "Decoding Error"]
        )
    }
    
    static let undefined = NSError(domain: HTTPErrorDomains.undefined, code: 0)
}

// MARK: - ServerError

struct ServerError {
    let statusCode: Int
    let body: String
}

// MARK: - RequestPerformerKeys

enum RequestPerformerKeys {
    static let errorBodyKey = "ErrorBodyKey"
}

// MARK: - HTTPErrorDomains

enum HTTPErrorDomains {
    static let decoding = "http.decoding.error"
    static let server = "http.server.error"
    static let undefined = "http.server.undefined"
}
