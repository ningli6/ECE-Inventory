//
//  UserDetailsViewController.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import Alamofire

class UserDetailsViewController: UITableViewController {
    
    // display information about this user
    var user: User?
    
    // pending requests
    var pendingRequests: [Request] = []
    
    let base_url = Shared.shared.base_url
    let query_url = "/api/transfers/user/"
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display user name in the text label
        userNameLabel.text = user?.name
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { // ignore name cell
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath);
        
        if (cell?.textLabel?.text)! == "Ownership Transfer Requests" {
            self.pendingRequests.removeAll()
            let usernameWithSpace = user?.name!.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
            Alamofire.request(base_url + query_url + "\(usernameWithSpace!)").responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data!, options:JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                        for request in json {
                            let barcode = request["Ptag"] as! String
                            let sender = request["Sender"] as! String
                            let receiver = request["Receiver"] as! String
                            let status = request["Status"] as! NSNumber
                            let time = request["Time"] as! String
                            self.pendingRequests.append(Request(barcode: barcode, sender: sender, receiver: receiver, status: status, time: time))
                        }
                        self.performSegue(withIdentifier: "ShowTransferRequests", sender: nil)
                    } catch {
                        print("Error with Json: \(error)")
                    }
                }
            })
        }
    }
    
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowItemsList") {
            let itemsListView = segue.destination as! ItemsListViewController
            itemsListView.items = self.user?.items
        }
        
        if (segue.identifier == "ShowTransferRequests") {
            let requestsView = segue.destination as! RequestsViewController
            requestsView.pendingRequests = self.pendingRequests
            requestsView.name = self.user?.name
        }
    }

}
