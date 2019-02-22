//
//  Endpoint.swift
//  Cornell AppDev
//
//  Created by Austin Astorga on 11/27/18.
//  Copyright © 2018 Austin Astorga. All rights reserved.
//

import Foundation

struct Endpoint {
    static let config: Endpoint.Config = Endpoint.Config()

    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let method: Endpoint.Method
}

// Endpoint sub classes and enums
extension Endpoint {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    class Config {
        var scheme: String?
        var host: String?
        var port: Int?
        var commonPath: String?
    }
}

// Endpoint initializers
extension Endpoint {
    /// General initializer
    init<T: Codable>(path: String, queryItems: [URLQueryItem] = [], headers: [String: String] = [:], body: T? = nil, method: Endpoint.Method = .get) {
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.method = (body != nil) ? .post : method
        self.body = try? JSONEncoder().encode(body)
    }

    /// POST initializer
    init<T: Codable>(path: String, headers: [String: String] = [:], body: T) {
        self.path = path
        self.queryItems = []
        self.headers = headers
        self.method = .post

        //Encode body
        self.body = try? JSONEncoder().encode(body)
    }

    /// GET initializer
    init(path: String, queryItems: [URLQueryItem] = [], headers: [String: String] = [:]) {
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.method = .get
        self.body = nil
    }
}

// Endpoint url
extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        // Assert required values have been set
        assert(Endpoint.config.scheme != nil, "Endpoint: scheme has not been set")
        assert(Endpoint.config.host != nil, "Endpoint: host has not been set")
        
        components.scheme = Endpoint.config.scheme
        components.host = Endpoint.config.host

        // Check for common path variable
        if let cPath = Endpoint.config.commonPath {
            components.path = "\(cPath)\(path)"
        } else {
            components.path = path
        }

        // Check if port has been set
        if let port = Endpoint.config.port {
            components.port = port
        }
        components.queryItems = queryItems
        return components.url
    }

    var urlRequest: URLRequest? {
        guard let unwrappedURL = url else { return nil }
        var request = URLRequest(url: unwrappedURL)
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method.rawValue
        request.httpBody = body

        return request
    }
}

