//
//  AAStubbedServer.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 07/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit
/*
 This is stubbed class to run the application development offline
*/
class AAStubbedServer: NSObject {
    static let sharedInstance = AAStubbedServer()
    private override init() {}
    
    func loadProducts() -> Data? {
        if let path = Bundle.main.path(forResource: "products", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        return nil
    }
}
