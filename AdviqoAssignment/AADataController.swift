//
//  AADataController.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 01/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit
import CoreData

class AADataController: NSObject {
    static let sharedInstance = AADataController()
    private let searchUrl = "https://api.mercadolibre.com/sites/MLA/search?q="
    private override init() {
        super.init()
        self.clearData()
    }
    
    /**
     call this method to load users
     */
    func searchProducts(searchString: String) {
        let string = searchUrl + searchString
        AAServiceFetcher().fetchData(url: URL(string: string)) { (status, data, error) in
            guard let data = data else { return }
            self.handleData(data: data)
        }
    }
    
    
    /**
     Private method
     */
    private func handleData(data: Data) {
        do {
         let decoder = JSONDecoder()
         let productList = try decoder.decode(AAProducts.self, from: data)
         self.saveInCoreDataWith(products: productList)
        } catch let err {
            print("Err", err)
        }
    }
    

    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Product.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fetchTime", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AACoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    
    private func createProductFrom(product: AAProductData) -> NSManagedObject? {
        let context = AACoreDataStack.sharedInstance.persistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            fetchRequest.predicate = NSPredicate(format: "pid = %@", product.productId!)
            let products = try context.fetch(fetchRequest)
            // we shouldn't have any duplicates in Products
            let productEntity: Product
            if let existingProduct = products.first as? Product {
                // we've got the product already cached!
                productEntity = existingProduct
            } else {
                // creating a new entity
                guard let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as? Product else {
                    return nil
                }
                newProduct.pid = product.productId
                productEntity = newProduct
            }
            productEntity.price = product.productPrice as NSDecimalNumber
            productEntity.title = product.productTitle
            productEntity.imagePath = product.productThumbnail
            productEntity.fetchTime = NSDate() as Date
            self.downloadProductThumbnail(product: productEntity)
            return productEntity
        } catch {
            // handle error
        }
        return nil
    }
    
    func saveInCoreDataWith(products: AAProducts) {
        _ = products.products.map{self.createProductFrom(product: $0)}
        do {
            try AACoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            
            let context = AACoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Product.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                AACoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

extension AADataController {
    private func downloadProductThumbnail(product: Product) {
        var task: URLSessionDownloadTask!
        let session: URLSession!
        session = URLSession.shared
        task = URLSessionDownloadTask()
        if product.thumbnail == nil {
            let url:URL! = URL(string: product.imagePath!)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async(execute: { () -> Void in
                        product.thumbnail = data
                        do {
                            try product.managedObjectContext?.save()
                        } catch let error {
                            print(error)
                        }
                        
                    })
                }
            })
            task.resume()
        }
    }
}
