//
//  GraphQLEncoder.swift
//  FutureNova
//
//  Created by Drew Dunne on 5/10/19.
//

import Foundation

public class GraphQLEncoder {

    /// Encodes a class into a GraphQL query string
    public static func encodeBody(_ theClass: Decodable.Type) -> String {
        let encoder = StringEncoder()
        encoder.encode(theClass)
        return encoder.asString()
    }

    /// Encodes arguments into a GraphQL argument tuple
    public static func encodeArgs(_ dict: [String: CustomStringConvertible]) -> String {
        var s = "("
        var i = 0
        for (key, value) in dict {
            s += "\(key): \(value)"
            if i < dict.count - 1 {
                s += ","
            }
            i += 1
        }
        s += ")"
        return s
    }

    public static func encode(name: String, args: [String: CustomStringConvertible]? = nil,
                              nestedResponse respClass: Decodable.Type) -> String {
        let argsStr = args != nil ? encodeArgs(args!) : ""
        let graphBody = encodeBody(respClass)
        let graphQl = "{\(name)\(argsStr)\(graphBody)}"
        #if DEBUG
        print(graphQl)
        #endif
        return graphQl
    }

    private class StringEncoder {

        private var body: String

        public init() {
            body = ""
        }

        public func encode(_ theClass: Decodable.Type) {
            // Get properties at first depth
            let props = try! theClass.decodeProperties(depth: 0)
            body += "{"
            for prop in props {
                body += prop.path[0]

                // Check if there are more nested properties
                if let t = prop.type as? Decodable.Type, try! t.decodeProperties(depth: 0).count > 0 {
                    encode(t)
                }

                // Check if we're doing the last property
                if let last = props.last, last.path != prop.path {
                    body += ","
                }
            }
            body += "}"
        }

        public func asString() -> String {
            return body
        }

    }
}
