//
//  ParameterEncoder.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - ParametersEncoder

protocol ParametersEncoder {
    func encode(parameters: [String: Any], in request: URLRequest) throws -> URLRequest
}

// MARK: - URLParameretersEncoder

struct URLParameretersEncoder: ParametersEncoder {
    
    func encode(parameters: [String: Any], in request: URLRequest) throws -> URLRequest {
        var request = request
        var query = "?"
        
        parameters.forEach {
            query.append("\($0.key)=\($0.value)&")
        }
        
        // Removes last component of the query.
        query.removeLast()
        guard
            let urlString = request.url?.absoluteString,
            let encoded = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: urlString + encoded)
        else {
            throw NSError("An error occured while encoding parameters")
        }
        request.url = url
        return request
    }
    
    func encode(parameters: [String: String], in request: URLRequest) throws -> URLRequest {
        var request = request
        var query = "?"
        
        parameters.forEach {
            query.append("\($0.key)=\($0.value)&")
        }
        
        // Removes last component of the query.
        query.removeLast()
        guard
            let urlString = request.url?.absoluteString,
            let encoded = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: urlString + encoded)
        else {
            throw NSError("An error occured while encoding parameters")
        }
        request.url = url
        return request
    }
}

// MARK: - JSONParametersEncoder

struct JSONParametersEncoder: ParametersEncoder {
    func encode(parameters: [String: Any], in request: URLRequest) throws -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let value = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = value
        return request
    }
}
