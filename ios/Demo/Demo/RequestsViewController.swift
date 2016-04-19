//
//  RequestsViewController.swift
//  Demo
//
//  Created by Ning Li on 4/7/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import Alamofire

class RequestsViewController: UITableViewController {
    
    // name of user
    var name: String?
    
    // selected item
    var item: Item?
    
    // pending requests
    var pendingRequests: [Request]?
    
    let base_url = "http://13.92.99.2"
    
    let query_url = "/api/items/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pendingRequests == nil ? 0 : pendingRequests!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath)

        // Configure the cell...
        let r = self.pendingRequests![indexPath.row]
        cell.textLabel?.text = "Item barcode: \(r.barcode!)"
        if self.name == r.sender {
            cell.detailTextLabel?.text = "To: \(r.receiver!)  \(r.time!)"
        } else {
            cell.detailTextLabel?.text = "From: \(r.sender!)  \(r.time!)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        let str = cell!.textLabel!.text
        let barcode = str!.substringWithRange(Range<String.Index>(start: str!.startIndex.advancedBy(14), end: str!.endIndex.advancedBy(0)))
        Alamofire.request(.GET, base_url + query_url + "\(barcode)").responseJSON(completionHandler: { response in
            if response.response?.statusCode == 200 {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options:NSJSONReadingOptions()) as! [[String: AnyObject]]
                    let item = json[0]
                    // huge ugly init
                    let owner = item["Owner"] is NSNull ? "" : item["Owner"] as! String
                    let orgnCode = item["OrgnCode"] is NSNull ? "" : item["OrgnCode"] as! String
                    let orgnTitle = item["OrgnTitle"] is NSNull ? "" : item["OrgnTitle"] as! String
                    let room = item["Room"] is NSNull ? "" : item["Room"] as! String
                    let bldg = item["Bldg"] is NSNull ? "" : item["Bldg"] as! String
                    let sortRoom = item["SortRoom"] is NSNull ? "" : item["SortRoom"] as! String
                    let ptag = item["Ptag"] is NSNull ? "" : item["Ptag"] as! String
                    let manufacturer = item["Manufacturer"] is NSNull ? "" : item["Manufacturer"] as! String
                    let model = item["Model"] is NSNull ? "" : item["Model"] as! String
                    let sn = item["SN"] is NSNull ? "" : item["SN"] as! String
                    let description = item["Description"] is NSNull ? "" : item["Description"] as! String
                    let custodian = item["Custodian"] is NSNull ? "" : item["Custodian"] as! String
                    let po = item["PO"] is NSNull ? "" : item["PO"] as! String
                    let acqDate = item["AcqDate"] is NSNull ? "" : item["AcqDate"] as! String
                    let amt = item["Amt"] is NSNull ? "" : item["Amt"] as! String
                    let ownership = item["Ownership"] is NSNull ? "" : item["Ownership"] as! String
                    let schevYear = item["SchevYear"] is NSNull ? "" : item["SchevYear"] as! String
                    let tagType = item["TagType"] is NSNull ? "" : item["TagType"] as! String
                    let assetType = item["AssetType"] is NSNull ? "" : item["AssetType"] as! String
                    let atypTitle = item["AtypTitle"] is NSNull ? "" : item["AtypTitle"] as! String
                    let condition = item["Condition"] is NSNull ? "" : item["Condition"] as! String
                    let lastInvDate = item["LastInvDate"] is NSNull ? "" : item["LastInvDate"] as! String
                    let designation = item["Designation"] is NSNull ? "" : item["Designation"] as! String
                    
                    self.item = Item(owner: owner, orgnCode: orgnCode, orgnTitle: orgnTitle, room: room, bldg: bldg, sortRoom: sortRoom, ptag: ptag, manufacturer: manufacturer, model: model, sn: sn, description: description, custodian: custodian, po: po, acqDate: acqDate, amt: amt, ownership: ownership, schevYear: schevYear, tagType: tagType, assetType: assetType, atypTitle: atypTitle, condition: condition, lastInvDate: lastInvDate, designation: designation)
                    self.performSegueWithIdentifier("PeekItemsByTransferRequests", sender: nil)
                } catch {
                    print("Error with Json: \(error)")
                }
            }
        })
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "PeekItemsByTransferRequests") {
            let itemDetailView = segue.destinationViewController as! ItemDetailsViewController
            itemDetailView.item = self.item
            itemDetailView.returnToSearchTab = false
        }
    }

}
