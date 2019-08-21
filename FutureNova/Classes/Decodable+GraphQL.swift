//
//  Decodable+GraphQL.swift
//  FutureNova
//
//  Created by Drew Dunne on 5/10/19.
//

import Foundation

extension Decodable {
    /// Decodes all `CodableProperty`s for this type. This requires that all propeties on this type are `GraphQLDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperties(depth:)` on `Reflectable`.
    ///
    /// - parameters: depth: The level of nesting to use.
    ///                      If `0`, the top-most properties will be returned.
    ///                      If `1`, the first layer of nested properties, and so-on.
    /// - throws: Any error decoding this type's properties.
    /// - returns: All `GraphQLProperty`s at the specified depth.
    public static func decodeProperties(depth: Int) throws -> [GraphQLProperty] {
        let context = GraphQLDecoderContext(activeOffset: 0, maxDepth: 42)
        let decoder = GraphQLDecoder(codingPath: [], context: context)
        _ = try Self(from: decoder)
        return context.properties.filter { $0.path.count == depth + 1 }
    }

    /// Decodes all `CodableProperty`s for this type. This requires that all propeties on this type are `GraphQLDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperties(depth:)` on `Reflectable`.
    ///
    /// - throws: Any error decoding this type's properties.
    /// - returns: All `GraphQLProperty`s at the specified depth.
    public static func decodeProperties() throws -> [GraphQLProperty] {
        let context = GraphQLDecoderContext(activeOffset: 0, maxDepth: 42)
        let decoder = GraphQLDecoder(codingPath: [], context: context)
        _ = try Self(from: decoder)
        return context.properties
    }

    /// Decodes a `CodableProperty` for the supplied `KeyPath`. This requires that all propeties on this
    /// type are `GraphQLDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperty(forKey:)` on `Reflectable`.
    ///
    /// - parameters:
    ///     - keyPath: `KeyPath` to decode a property for.
    /// - throws: Any error decoding this property.
    /// - returns: `GraphQLProperty` if one was found.
//    public static func decodeProperty<T>(forKey keyPath: KeyPath<Self, T>) throws -> GraphQLProperty? {
//        return try anyDecodeProperty(valueType: T.self, keyPath: keyPath)
//    }

    /// Decodes a `CodableProperty` for the supplied `KeyPath`. This requires that all propeties on this
    /// type are `GraphQLDecodable`.
    ///
    /// This is used to provide a default implementation for `reflectProperty(forKey:)` on `Reflectable`.
    ///
    /// - parameters:
    ///     - keyPath: `AnyKeyPath` to decode a property for.
    /// - throws: Any error decoding this property.
//    public static func anyDecodeProperty(valueType: Any.Type, keyPath: AnyKeyPath) throws -> GraphQLProperty? {
//        guard valueType is AnyGraphQLDecodable.Type else {
//            throw GraphQLError(msg: "`\(valueType)` does not conform to `GraphQLDecodable`.")
//        }
//
//        if let cached = GraphQLPropertyCache.storage[keyPath] {
//            return cached
//        }
//
//        var maxDepth = 0
//        a: while true {
//            defer { maxDepth += 1 }
//            var activeOffset = 0
//
//            if maxDepth > 42 {
//                return nil
//            }
//
//            b: while true {
//                defer { activeOffset += 1 }
//                let context = GraphQLDecoderContext(activeOffset: activeOffset, maxDepth: maxDepth)
//                let decoder = GraphQLDecoder(codingPath: [], context: context)
//
//                let decoded = try Self(from: decoder)
//                guard let codingPath = context.activeCodingPath else {
//                    // no more values are being set at this depth
//                    break b
//                }
//
//                guard let t = valueType as? AnyGraphQLDecodable.Type, let left = decoded[keyPath: keyPath] else {
//                    break b
//                }
//
//                if try t.anyReflectDecodedIsLeft(left) {
//                    let property = GraphQLProperty(any: valueType, at: codingPath.map { $0.stringValue })
//                    GraphQLPropertyCache.storage[keyPath] = property
//                    return property
//                }
//            }
//        }
//    }
}

/// Caches derived `GraphQLProperty`s so that they only need to be decoded once per thread.
final class GraphQLPropertyCache {
    /// Thread-specific shared storage.
    static var storage: [AnyKeyPath: GraphQLProperty] {
        get {
            let cache = GraphQLPropertyCache.cache
            return cache.storage
        }
        set {
            let cache = GraphQLPropertyCache.cache
            cache.storage = newValue
            GraphQLPropertyCache.cache = cache
        }
    }

    /// Private `ThreadSpecificVariable` powering this cache.
    private static var cache: GraphQLPropertyCache = .init()

    /// Instance storage.
    private var storage: [AnyKeyPath: GraphQLProperty]

    /// Creates a new `GraphQLPropertyCache`.
    init() {
        self.storage = [:]
    }
}
