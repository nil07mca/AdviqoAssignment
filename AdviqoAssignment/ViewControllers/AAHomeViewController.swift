//
//  AAHomeViewController.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 06/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit
import CoreData

/*
 This class is for home and recent viewed items screen
 */
class AAHomeViewController: UITableViewController {
    private var recentViewed: [Product]?
    
    // MARK: - string constants
    private let recentProductsHeader = "Recent viewed products"
    private let segueIdentifier = "showDetail"
    private let mainStoryboard = "Main"
    private let productList = "AAProductListingViewController"
    private let cellIdentifier = "recentProductCell"
    private let placeHolderImage = "placeholder"
    private let titleText = "Niladri iOS Assignment"
    private let currencySymbol = "€"
    private let backButtonTitle = "Back"
    private let alertTitle = "Warning !!!"
    private let alertMessage = "Would you like to clear cached data?"
    private let alertOkButton = "Ok"
    private let alertCancelButton = "Cancel"
    // MARK: -
    
    @IBAction func clearCache(_ sender: Any) {
        self.showAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentViewed = AAProductManager.sharedInstance.lastVisitedProducts()
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = recentViewed?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let count = recentViewed?.count {
            if count > 0 {
                return recentProductsHeader
            }
        }

        // This should never happen, but is a fail safe
        return ""
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = self.configureCell(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func configureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let product = recentViewed?[indexPath.row] {
            cell.textLabel?.text = product.title
            cell.detailTextLabel?.text = "\(currencySymbol) \(product.price ?? 0)"
            if let imageData = product.thumbnail {
                cell.imageView?.image = UIImage(data: imageData)
            } else {
                cell.imageView?.image = UIImage(named:placeHolderImage)
            }
        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow{
            guard let product = recentViewed?[indexPath.row] else { return }
            let detailVC = segue.destination as! AAProductDetailsViewController
            detailVC.product = product
            let backItem = UIBarButtonItem()
            backItem.title = backButtonTitle
            navigationItem.backBarButtonItem = backItem
        }
    }
}

extension AAHomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
        if let viewController = UIStoryboard(name: mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: productList) as? AAProductListingViewController {
            if let navigator = navigationController {
                let backItem = UIBarButtonItem()
                backItem.title = backButtonTitle
                navigationItem.backBarButtonItem = backItem
                viewController.searchString = searchText
                navigator.pushViewController(viewController, animated: true)
            }
        } 
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension AAHomeViewController {
    
    func showAlert() {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: alertOkButton, style: UIAlertActionStyle.default, handler: { _ in
            AADataController.sharedInstance.clearData()
            self.recentViewed = AAProductManager.sharedInstance.lastVisitedProducts()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: alertCancelButton, style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

