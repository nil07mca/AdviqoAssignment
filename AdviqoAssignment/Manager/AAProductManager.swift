//
//  AAProductManager.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 06/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit
import CoreData

/*
 This class is for single point interface for all product related stuffs
 */
class AAProductManager: NSObject {
    static let sharedInstance = AAProductManager()
    private static let productSearchLink = "https://api.mercadolibre.com/sites/MLA/search?q="
    
    private override init() {}
    
    /*
     call this method to search product
     - parameters:
        - searchString as String
     */
    func searchProducts(searchString: String) {
        #if STUBBED
            print("STUBBED")
            guard let data = AAStubbedServer.sharedInstance.loadProducts() else {
                return
            }
            self.handleData(data: data)
        #else
            print("LIVE")
            let queryString = type(of: self).productSearchLink + searchString
            AAServiceFetcher().fetchData(url: URL(string: queryString)) { (status, data, error) in
                guard let data = data else { return }
                self.handleData(data: data)
            }
        #endif

    }
    
    /*
     call this method to fetch 5 last visited products
     - return:
        - list of products as Product array
    */
    func lastVisitedProducts() -> [Product]? {
        var recentViewed: [Product]?
        do {
            let context = AACoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            let predicate = NSPredicate(format: "isViewed == %@", NSNumber(value: true))
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastVisited", ascending: false)]
            fetchRequest.fetchLimit = 5
            recentViewed = try context.fetch(fetchRequest) as? [Product]
        } catch {
            // handle error
        }
        return recentViewed
    }
    
    /*
     call this method to update product
     - parameters:
        - product as Product NSManagedObject
     */
    func updateProductWhenViewed(product: Product) {
        product.isViewed = true
        product.lastVisited = NSDate() as Date
        do {
            try product.managedObjectContext?.save()
        } catch let error {
            print(error)
        }
    }
    
    /**
     Private method to handle data
     */
    private func handleData(data: Data) {
        do {
            let decoder = JSONDecoder()
            let productList = try decoder.decode(AAProducts.self, from: data)
            AADataController.sharedInstance.saveInCoreDataWith(products: productList)
        } catch let err {
            print("Error", err)
        }
    }
}
