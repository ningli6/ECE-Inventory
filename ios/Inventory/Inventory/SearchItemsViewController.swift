//
//  SearchItemsViewController.swift
//  Inventory
//
//  Created by Ning Li on 2/9/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class SearchItemsViewController: UIViewController {

    var name: String?
    var itemId: Int?
    
    @IBOutlet weak var itemNameLable: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func lookForItems(sender: UIButton) {
        
        if (searchBar.text == "") {
            itemNameLable.text = "Need input!"
            return
        }

        itemId = Int(searchBar.text!)
        print(itemId!)
        
        let url = "http://eceinventory2.azurewebsites.net/api/items/" + String(itemId!)
        print(url)
        let requestURL: NSURL = NSURL(string: url)!
//        let requestURL: NSURL = NSURL(string: "http://eceinventory2.azurewebsites.net/api/items/1")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    self.name = json["Name"] as? String
                    print(self.name)
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        self.itemNameLable.text = self.name
                    })
                }catch {
                    print("Error with Json: \(error)")
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    // code here
                    self.itemNameLable.text = String(statusCode)
                })
            }
        }
        task.resume()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
