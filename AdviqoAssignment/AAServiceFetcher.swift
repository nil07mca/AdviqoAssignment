//
//  AAServiceFetcher.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 01/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit

class AAServiceFetcher: NSObject {
    typealias ResponseHandler = (_ status: Bool, _ json: Data?, _ error: Error?) -> Void
    /**
     call this method to initiate service call
     - parameters:
     - url as URL object
     - handler as ResponseHandler
     */
    func fetchData(urlSession: URLSession = URLSession(
        configuration: URLSessionConfiguration.default),
                    url: URL?,
                    handler: @escaping ResponseHandler) {
        guard let url = url else {
            return
        }
        let task = urlSession.dataTask(with: url, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse,
                let data = data else {
                    handler(false, nil, error)
                    return
            }
            self.handleResponse(urlResponse:response, data: data, error: error, handler: handler)
        })
        task.resume()
    }
    
    /**
     Private method for handle response
     */
    private func handleResponse(urlResponse: HTTPURLResponse, data: Data, error: Error?, handler: ResponseHandler?) {
        guard urlResponse.statusCode < 400 else {
            handler?(false, nil, error)
            return
        }
        handler?(true, data, error)
    }
}
