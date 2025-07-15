//
//  RequestFactory.swift
//  iOS Platform Assessment
//
//  Created by Olami on 2025-07-15.
//

import Foundation

// MARK: - RequestFactoryProviding

/// A protocol for making network requests with various configurations.
protocol RequestFactoryProviding {
    
    /// Makes an asynchronous network request with the given builder and cache policy.
    /// - Parameters:
    ///   - builder: The request configuration.
    ///   - cachePolicy: The cache policy for the request.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: An error of type `APIError`.
    func request<T: Codable>(with builder: BaseRequest, cachePolicy: URLRequest.CachePolicy) async throws -> T
    
    /// Makes an asynchronous network request with the given builder, cache policy, custom decoder, retry and authentication options.
    /// - Parameters:
    ///   - builder: The request configuration.
    ///   - cachePolicy: The cache policy for the request.
    ///   - customDecoder: A custom JSON decoder to use for decoding the response.
    ///   - allowRetry: A boolean indicating whether the request should be retried in case of failure.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: An error of type `APIError`.
    func request<T: Codable>(with builder: BaseRequest, cachePolicy: URLRequest.CachePolicy, customDecoder: JSONDecoder) async throws -> T
    
    /// Makes an asynchronous network request with the given builder and custom decoder.
    /// - Parameters:
    ///   - builder: The request configuration.
    ///   - customDecoder: A custom JSON decoder to use for decoding the response.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: An error of type `APIError`.
    func request<T: Codable>(with builder: BaseRequest, customDecoder: JSONDecoder) async throws -> T
    
    /// Makes an asynchronous network request with the given builder and authentication option.
    /// - Parameters:
    ///   - builder: The request configuration.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: An error of type `APIError`.
    func request<T: Codable>(with builder: BaseRequest) async throws -> T
}

// MARK: - RequestFactory

struct RequestFactory: RequestFactoryProviding {
    
    // MARK: Internal
    
    func request<T>(with builder: BaseRequest) async throws -> T where T: Codable {
        try await request(with: builder, cachePolicy: .useProtocolCachePolicy, customDecoder: JSONDecoder())
    }
    
    func request<T: Codable>(with builder: BaseRequest, customDecoder: JSONDecoder) async throws -> T where T: Codable {
        try await request(with: builder, cachePolicy: .useProtocolCachePolicy, customDecoder: JSONDecoder())
    }
    
    func request<T>(with builder: BaseRequest, cachePolicy: URLRequest.CachePolicy) async throws -> T where T: Codable {
        try await request(with: builder, cachePolicy: cachePolicy, customDecoder: JSONDecoder())
    }
    
    func request<T>(with builder: BaseRequest, cachePolicy: URLRequest.CachePolicy, customDecoder: JSONDecoder) async throws -> T where T: Codable {
        
        let encoding: ParametersEncoder = [.get, .delete].contains(builder.method) ? URLParameretersEncoder() : JSONParametersEncoder()
        customDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = builder.baseUrl
            components.path = "/api/v1" + builder.path
            
            guard let url = components.url else {
                preconditionFailure("Invalid URL components: \(components)")
            }
            
            return url
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = builder.method.rawValue
        for (key, value) in builder.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = builder.parameters {
            guard let encoded = try? encoding.encode(parameters: parameters, in: urlRequest) else {
                fatalError()
            }
            urlRequest = encoded
        }
        
#if DEBUG
        self.log(request: urlRequest)
#endif
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
#if DEBUG
        self.log(response: response, data: data, error: nil)
#endif
        
        if (200...299).contains(response.statusCode) {
            let decoded = try customDecoder.decode(T.self, from: data)
            return decoded
        } else {
            
            
            do {
                let errorResponse = try customDecoder.decode(BaseResponse.self, from: data)
                throw APIError.server(response: errorResponse)
                
            } catch let decodingError as DecodingError {
                var errorMessage = "Failed to decode the response."
                
                switch decodingError {
                case .typeMismatch(let type, let context):
                    errorMessage += " Type mismatch for type \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
                case .valueNotFound(let type, let context):
                    errorMessage += " Value not found for type \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
                case .keyNotFound(let key, let context):
                    errorMessage += " Key '\(key.stringValue)' not found at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
                case .dataCorrupted(let context):
                    errorMessage += " Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
                @unknown default:
                    errorMessage += " Unknown decoding error."
                }
                
                let userInfo = [NSLocalizedDescriptionKey: errorMessage]
                let error = NSError(domain: "com.yourdomain.api", code: -1, userInfo: userInfo)
                throw APIError.decodingError(underlyingError: error)
            } catch {
                throw error
            }
            
        }
    }
    
    // MARK: Private
    
    private func log(response: HTTPURLResponse?, data: Data?, error: Error?) {
        print("\n - - - - - - - - - - INCOMMING RESPONSE - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END RESPONSE - - - - - - - - - - \n") }
        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        var output = ""
        if let urlString = urlString {
            output += "\(urlString)"
            output += "\n\n"
        }
        if let statusCode =  response?.statusCode {
            output += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host {
            output += "Host: \(host)\n"
        }
        for (key, value) in response?.allHeaderFields ?? [:] {
            output += "\(key): \(value)\n"
        }
        if let body = data {
            output += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
        }
        if error != nil {
            output += "\nError: \(String(describing: error))\n"
            output += "\nError: \(error!.localizedDescription)\n"
        }
        print(output)
    }
    
    private func log(request: URLRequest) {
        print("\n - - - - - - - - - - OUTGOING REQUEST - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END REQUEST - - - - - - - - - - \n") }
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAsString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        var output = """
           \(urlAsString) \n\n
           \(method) \(path)?\(query) HTTP/1.1 \n
           HOST: \(host)\n
           """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            output += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            output += "\n \(String(data: body, encoding: .utf8) ?? "")"
        }
        print(output)
    }
    
}
