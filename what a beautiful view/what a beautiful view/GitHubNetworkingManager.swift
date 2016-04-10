//
//  GitHubNetworkingManager.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/2/7.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//


//Improve Reuse of Networking Code
import UIKit

class GitHubNetworkingManager {
    static let sharedInstance = GitHubNetworkingManager()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    
    /// - Attributions: http://krakendev.io/blog/the-right-way-to-write-a-singleton
    func grabSomeData(urlString: String, completion:([[String: AnyObject]]?) -> Void) {
        
        // Test that we can convert the `String` into an `NSURL` object.  If we can
        // not, then crash the application.
        guard let url = NSURL(string: urlString)  else {
            fatalError("No URL")
        }
        
        // Create a `NSURLSession` object
        let session = NSURLSession.sharedSession()
        
        // Create a task for the session object to complete
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // Check for errors that occurred during the download.  If found, execute
            // the completion block with `nil`
            guard error == nil else {
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                completion(nil)
                return
            }
            
            // Print the response headers (for debugging purpose only)
           // print(response)
            
            // Test that the data has a value and unwrap it to the variable `let`.  If
            // it is `nil` than pass `nil` to the completion closure.
            guard let data = data else {
                print("There was no data")
                completion(nil)
                return
            }
            
            // Unserialze the JSON that was retrieved into an Array of Dictionaries.
            // Pass is as parameter to the completion block.
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let issues = json as? [[String: AnyObject]] {
                    completion(issues)   
                }
            } catch {
                print("error serializing JSON: \(error)")
                completion(nil)
            }
        })
        
        // Start the downloading.  NSURLSession objects are created in the paused
        // state, so to start it we need to tell it to *resume*
        
        task.resume()
    }
}