//
//  AAProductListingViewController.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 01/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit
import CoreData

/*
 This class is for search result screen
 */
class AAProductListingViewController: UITableViewController {
    var searchString: String?
    private let fetchedhResultController = AADataController.sharedInstance.fetchedhResultController
    
    // MARK: - string constants
    private let headerTitlePrefix = "Showing result for"
    private let segueIdentifier = "showDetailsSegue"
    private let noRecordMessage = "no records found"
    private let backButtonTitle = "Back"
    private let cellIdentifier = "productCell"
    private let placeHolderImage = "placeholder"
    private let currencySymbol = "€"
    
    
    // MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(headerTitlePrefix) \(searchString ?? "")"
        self.showProducts()
        guard let searchString = searchString else { return }
        AAProductManager.sharedInstance.searchProducts(searchString: searchString)
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
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = self.configureCell(indexPath: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            if count == 0 {
                return noRecordMessage
            }
        }
        return ""
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow{
            guard let product = fetchedhResultController.object(at: indexPath) as? Product else { return }
            let detailVC = segue.destination as! AAProductDetailsViewController
            detailVC.product = product
            
            let backItem = UIBarButtonItem()
            backItem.title = backButtonTitle
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    func configureCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let product = fetchedhResultController.object(at: indexPath) as? Product {
            cell.textLabel?.text = product.title
            cell.detailTextLabel?.text = "\(currencySymbol) \(product.price ?? 0)"
            if let imageData = product.thumbnail {
                cell.imageView?.image = UIImage(data: imageData)
            } else {
                cell.imageView?.image = UIImage(named: placeHolderImage)
            }
        }
        return cell
    }

}

// MARK: - Fetched  result controller methods
extension AAProductListingViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        /* Delete is currently not applicable for our case */
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
}

extension AAProductListingViewController {
    // Call this methos to fetch products from core data
    func showProducts()
    {
        do {
            fetchedhResultController.delegate = self
            try fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
}

