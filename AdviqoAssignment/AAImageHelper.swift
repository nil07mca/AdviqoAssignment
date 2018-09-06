//
//  AAImageHelper.swift
//  AdviqoAssignment
//
//  Created by Niladri Chatterjee on 01/09/2018.
//  Copyright © 2018 Niladri Chatterjee. All rights reserved.
//

import UIKit

class AAImageHelper: NSObject {
    private var task: URLSessionDownloadTask!
    private var session: URLSession!
    private static let cache:NSCache<AnyObject, AnyObject> = NSCache()
    
    
    /**
     call this method to load users
     - parameters:
     - container as UIImageView
     - imagePath as String
     */
    func showImage(container: UIImageView, imagePath: String) {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        if (AAImageHelper.cache.object(forKey: imagePath as AnyObject) != nil){
            container.image = AAImageHelper.cache.object(forKey: imagePath as AnyObject) as? UIImage
        }else{
            let url:URL! = URL(string: imagePath)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async(execute: { () -> Void in
                        let img:UIImage! = UIImage(data: data)
                        container.image = img
                        AAImageHelper.cache.setObject(img, forKey: imagePath as AnyObject)
                        
                    })
                }
            })
            task.resume()
        }
    }
}
