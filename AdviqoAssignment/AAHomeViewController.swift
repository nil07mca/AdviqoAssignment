//
//  AAHomeViewController.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 06/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit

class AAHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    private func showProductListing(searchString: String) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AAProductListingViewController") as? AAProductListingViewController {
            viewController.searchString = searchString
        self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func showError() {
        print("Error")
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension AAHomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let pruductQuery = searchBar.text else { return }
        self.showProductListing(searchString: pruductQuery)
    }
}
