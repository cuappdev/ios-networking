//
//  GraphQLExample.swift
//  FutureNova_Example
//
//  Created by Drew Dunne on 5/10/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {

    static func getEateries(id: Int?) -> Endpoint {
        let args = id != nil ? ["id": id!] : nil
        return graphQLEndpoint("eateries", args: args, nestedResponse: Eatery.self)
    }

}

enum EateryError: Error {
    case error
}

enum PaymentMethods: String, Codable, CaseIterable, GraphQLDecodable {
    case brb = "BRB"
    case cash = "CASH"
    case credit = "CREDIT"
    case cornellCard = "CORNELL_CARD"
    case mobile = "MOBILE"
    case swipes = "SWIPES"
}

struct FoodStation: Codable {
    let category: String
}

struct FoodCategory: Codable {
    let category: String
    let stations: [FoodStation]
}

struct Eatery: Codable {
    let id: Int
    let name: String
    let paymentMethodsEnums: [PaymentMethods]
    let expandedMenu: [FoodCategory]
}

struct EateryResp: Codable {
    let eateries: [Eatery]
}

struct APIErrors: Codable {
    let message: String
    let locations: [Location]

    struct Location: Codable {
        let line: Int
        let column: Int
    }
}

struct APIResponse<T: Codable>: Codable {
    let data: T?
    let errors: [APIErrors]?
}
