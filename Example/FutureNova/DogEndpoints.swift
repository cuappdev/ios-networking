//
//  DogEndpoints.swift
//  FutureNova_Example
//
//  Created by Drew Dunne on 2/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {

    /// Grabs a random dog breed image
    static func randomDogBreed() -> Endpoint {
        return Endpoint(path: "/breeds/image/random")
    }

    /// Grabs specific image data
    static func dogBreedImage(breed: String, id: String) -> Endpoint {
        return Endpoint(path: "/breeds/\(breed)/\(id)", useCommonPath: false, customHost: "images.dog.ceo")
    }
    
}
