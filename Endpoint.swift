//
//  Endpoint.swift
//  Cornell AppDev
//
//  Created by Austin Astorga on 11/27/18.
//  Copyright © 2018 Austin Astorga. All rights reserved.
//

import Foundation


enum EndpointMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

/// Looks at Secrets/Keys.plist file which should contain as key:
/// - "api-url" should be the host of the deployed backend url
enum Keys: String {
    case apiURL = "api-url"
    case apiDevURL = "api-dev-url"

    var value: String {
        switch self {
        case .apiDevURL: return "localhost"
        case .apiURL: return Keys.keyDict[rawValue] as! String
        }
    }

    static var hostURL: Keys {
        #if DEBUG
        return Keys.apiDevURL
        #else
        return Keys.apiURL
        #endif
    }

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}


struct Endpoint {
    static var apiVersion: Int?

    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let method: EndpointMethod
}

extension Endpoint {
    /// General initializer
    init<T: Codable>(path: String, queryItems: [URLQueryItem] = [], headers: [String: String] = [:], body: T? = nil, method: EndpointMethod = .get) {
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

extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = Keys.hostURL.value
        if let apiVersion = Endpoint.apiVersion {
            components.path = "/api/v\(apiVersion)/\(path)"
        } else {
            components.path = "/api/\(path)"
        }
        #if DEBUG
        components.port = 3000
        #endif
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

