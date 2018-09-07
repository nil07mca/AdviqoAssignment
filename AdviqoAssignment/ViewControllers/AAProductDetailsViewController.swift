//
//  AAProductDetailsViewController.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 06/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit

/*
 This class is for product details screen
 */
class AAProductDetailsViewController: UIViewController {
    
    var product: Product?
    private let pricePrefix = "Price: €"
    // MARK: - IBOutlets
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let product = product else { return }
        self.showProductInformation(product: product)
        self.updateProductWhenViewed(product: product)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showProductInformation(product: Product) {
        if let imageData = product.thumbnail {
            imgProduct.image = UIImage(data: imageData)
        }
        lblProductName.text = product.title
        lblPrice.text = "\(pricePrefix) \(product.price ?? 0)"
        self.title = product.pid
    }
}

extension AAProductDetailsViewController {
    func updateProductWhenViewed(product: Product) {
        AAProductManager.sharedInstance.updateProductWhenViewed(product: product)
    }
}
