//
//  DogEndpoints.swift
//  FutureNova_Example
//
//  Created by Drew Dunne on 2/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FutureNova

struct RefreshTokenResp: Codable {
    let success: Bool
    let token: String
    let expiration: Int
    let refreshToken: String
}

enum DogMiddleware {

    func checkSession(req: URLRequest) -> Future<URLRequest> {
        return URLSession.shared
            .request(endpoint: Endpoint.refreshToken("austins_basement:user=mattcoufal1942"))
            .decode(RefreshTokenResp.self)
            .transformed { resp in
                let newReq = req // pretend update headers
                return newReq
        }
    }
}

extension Endpoint {

    static func refreshToken(_ refreshToken: String) -> Endpoint {
        return Endpoint(path: "/refreshSession", queryItems: [URLQueryItem(name: "refreshToken", value: refreshToken)])
    }

    /// Grabs a random dog breed image
    static func randomDogBreed() -> Endpoint {
        return Endpoint(path: "/breeds/image/random")
    }

    /// Grabs specific image data
    static func dogBreedImage(breed: String, id: String) -> Endpoint {
        return Endpoint(path: "/breeds/\(breed)/\(id)", useCommonPath: false, customHost: "images.dog.ceo")
    }
    
}
