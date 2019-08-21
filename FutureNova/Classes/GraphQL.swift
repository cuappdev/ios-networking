//
//  GraphQL.swift
//  FutureNova
//
//  Created by Drew Dunne on 5/10/19.
//

import Foundation

/// Errors thrown through the GraphQL process
public struct GraphQLError: Error {
    /// The error message
    public var msg: String
}

/// Represents a property on a type that has been reflected using the `GraphQLCodable` protocol.
public struct GraphQLProperty {
    /// This property's type.
    public let type: Any.Type

    /// The path to this property.
    public let path: [String]

    /// Creates a new `GraphQLProperty` from a type and path.
    public init<T>(_ type: T.Type, at path: [String]) {
        self.type = T.self
        self.path = path
    }

    /// Creates a new `GraphQLProperty` using `Any.Type` and a path.
    public init(any type: Any.Type, at path: [String]) {
        self.type = type
        self.path = path
    }
}

extension GraphQLProperty: CustomStringConvertible {
    /// See `CustomStringConvertible.description`
    public var description: String {
        return "\(path.joined(separator: ".")): \(type)"
    }
}

extension Endpoint {

    /// Simple function for creating a GraphQL version of the Endpoint struct
    public static func graphQLEndpoint(_ name: String,
                                       args: [String: CustomStringConvertible]? = nil,
                                       nestedResponse respClass: Decodable.Type) -> Endpoint {
        let graphQl = GraphQLEncoder.encode(name: name, args: args, nestedResponse: respClass)
        return Endpoint(path: "/", queryItems: [URLQueryItem(name: "query", value: graphQl)])
    }

}
