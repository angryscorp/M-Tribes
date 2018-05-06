//
//  NetworkManager.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {

    /// Root URL for any requests
    private let rootURL = "http://data.m-tribes.com/"

    /// Request and loading main data
    func loadData(successHandler: @escaping ([Placemark]) -> Void, errorHandler: @escaping (Error?) -> Void) {

        let requestSubURL = "locations.json"

        guard let request = URLRequest.constructGET(rootURL+requestSubURL) else { return }

        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in

            if let error = error {
                errorHandler(error)
            }

            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        if let placemarks = (try? JSONDecoder().decode(PlacemarkJSON.self, from: data))?.placemarks {
                            successHandler(placemarks)
                        } else {
                            assertionFailure("Parsing JSON Error")
                            errorHandler(nil)
                        }
                    }
                default:
                    assertionFailure("Response's status code error: \(response.statusCode)")
                    errorHandler(NSError(domain: "", code: response.statusCode, userInfo: nil) as Error)
                }
            }
        }).resume()
        
    }

}
