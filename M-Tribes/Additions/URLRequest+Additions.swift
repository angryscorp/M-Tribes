//
//  URLRequest+Additions.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import Foundation

extension URLRequest {

    static func constructGET(_ stringURL: String) -> URLRequest? {

        guard let URL = URL(string: stringURL) else {
            assertionFailure("Error of create URL: \(stringURL)")
            return nil
        }

        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }

}
