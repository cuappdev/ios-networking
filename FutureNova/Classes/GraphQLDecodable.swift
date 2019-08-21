//
//  GraphQLDecodable.swift
//  FutureNova
//
//  Created by Drew Dunne on 5/10/19.
//

import Foundation

/// Protocol to allow encoding a GraphQL query
public protocol GraphQLDecodable: AnyGraphQLDecodable {
    /// A function that creates a basic instantiation, the values do not matter
    ///
    /// - returns: A basic instantiation
    static func emptyDecoded() throws -> Self
}

// MARK: Types

extension String: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> String { return "0" }
    
}

extension FixedWidthInteger {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> Self { return 0 }
}

extension UInt: GraphQLDecodable { }
extension UInt8: GraphQLDecodable { }
extension UInt16: GraphQLDecodable { }
extension UInt32: GraphQLDecodable { }
extension UInt64: GraphQLDecodable { }

extension Int: GraphQLDecodable { }
extension Int8: GraphQLDecodable { }
extension Int16: GraphQLDecodable { }
extension Int32: GraphQLDecodable { }
extension Int64: GraphQLDecodable { }

extension Bool: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> Bool { return false }
}

extension BinaryFloatingPoint {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> Self { return 0 }
}

extension Decimal: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> Decimal { return 0 }
}

extension Float: GraphQLDecodable { }
extension Double: GraphQLDecodable { }

extension UUID: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> UUID {
        return UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
    }
}

extension Data: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> Data { return Data([0x00]) }
}

extension Date: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() -> Date { return Date(timeIntervalSince1970: 1) }
}

extension Optional: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() throws -> Wrapped? {
        let reflected = try forceCast(Wrapped.self).anyEmptyDecoded()
        return reflected as? Wrapped
    }
}

extension Array: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() throws -> [Element] {
        let reflected = try forceCast(Element.self).anyEmptyDecoded()
        return [reflected as! Element]
    }
}

extension Dictionary: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() throws -> [Key: Value] {
        let reflectedValue = try forceCast(Value.self).anyEmptyDecoded()
        let reflectedKey = try forceCast(Key.self).anyEmptyDecoded()
        let key = reflectedKey as! Key
        return [key: reflectedValue as! Value]
    }
}

extension Set: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() throws -> Set<Element> {
        let reflected = try forceCast(Element.self).anyEmptyDecoded()
        return [reflected as! Element]
    }
}

extension URL: GraphQLDecodable {
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func emptyDecoded() throws -> URL { return URL(string: "https://fake.url")! }
}

// MARK: Type Erased

/// Type-erased version of `GraphQLDecodable`
public protocol AnyGraphQLDecodable {
    /// Type-erased version of `GraphQLDecodable.emptyDecoded()`.
    ///
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    static func anyEmptyDecoded() throws -> Any
}

extension GraphQLDecodable {
    /// Type-erased version of `GraphQLDecodable.emptyDecoded()`.
    ///
    /// See `GraphQLDecodable.emptyDecoded()` for more information.
    public static func anyEmptyDecoded() throws -> Any {
        return try emptyDecoded()
    }
}

/// Trys to cast a type to `AnyGraphQLDecodable.Type`. This can be removed when conditional conformance supports runtime querying.
func forceCast<T>(_ type: T.Type) throws -> AnyGraphQLDecodable.Type {
    guard let casted = T.self as? AnyGraphQLDecodable.Type else {
        throw GraphQLError(msg: "\(T.self) is not `GraphQLDecodable`")
    }
    return casted
}

#if swift(>=4.1.50)
#else
public protocol CaseIterable {
    static var allCases: [Self] { get }
}
#endif

extension GraphQLDecodable where Self: CaseIterable {
    /// Default implementation of `GraphQLDecodable` for enums that are also `CaseIterable`.
    ///
    /// See `GraphQLDecodable.emptyDecoded(_:)` for more information.
    public static func emptyDecoded() throws -> Self {
        /// enum must have at least 2 unique cases
        guard let first = allCases.first else {
                throw GraphQLError(msg: "\(Self.self) enum must have at least 1 case")
        }
        return first
    }
}
