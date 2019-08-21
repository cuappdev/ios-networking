//
//  ViewController.swift
//  FutureNova
//
//  Created by Drew Dunne on 02/22/2019.
//  Copyright (c) 2019 Drew Dunne. All rights reserved.
//

import UIKit
import FutureNova

class ViewController: UIViewController {

    private struct RandomDogResponse: Codable {
        let status: String
        let message: URL
    }

    enum DogError: Error {
        case failed(_ msg: String)
    }

    private let networking: Networking = URLSession.shared.request

    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        getRandomImage().chained { [weak self] result -> Future<Data> in
            let id = result.message.lastPathComponent
            let breed = result.message.deletingLastPathComponent().lastPathComponent
            guard let f = self?.networking(Endpoint.dogBreedImage(breed: breed, id: id)) else {
                return Promise<Data>(error: DogError.failed("Couldn't get endpoint for breed"))
            }
            return f
            }.chained { data -> Future<UIImage>  in
                guard let image = UIImage(data: data) else {
                    return Promise<UIImage>(error: DogError.failed("Couldn't convert data to image"))
                }
                return Promise<UIImage>(value: image)
            }.observe { [weak self] result in
                switch result {
                case .value(let image):
                    self?.imageLoaded(image: image)
                case .error(let error):
                    self?.presentError(with: error)
                }
        }

        getNastysEatery().chained { apiResp -> Future<[Eatery]> in
                print(apiResp)
                guard let data = apiResp.data else { return Promise<[Eatery]>(error: EateryError.error) }
                return Promise<[Eatery]>(value: data.eateries)
            }.observe { resp in
                switch resp {
                case .value(let eateries):
                    print(eateries)
                case .error(let err):
                    print(err)
                }
        }
    }

    func presentError(with error: Error) {
        print(error)
    }

    func imageLoaded(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

    private func getRandomImage() -> Future<RandomDogResponse> {
        return networking(Endpoint.randomDogBreed()).decode()
    }

    private func getNastysEatery() -> Future<APIResponse<EateryResp>> {
        return networking(Endpoint.getEateries(id: 1)).decode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

