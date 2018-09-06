//
//  AAProduct.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 01/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import Foundation
struct AAProducts: Codable {
    let products: [AAProductData]
    enum CodingKeys : String, CodingKey {
        case products = "results"
    }
}
struct AAProductData: Codable {
    // Mark: - Properties
    let productId: String?
    let productTitle: String?
    let productPrice: Decimal
    let productThumbnail: String?
    
    // Map between property and actual json keys
    private enum CodingKeys: String, CodingKey {
        case productId = "id"
        case productTitle = "title"
        case productPrice = "price"
        case productThumbnail = "thumbnail"
    }
}
