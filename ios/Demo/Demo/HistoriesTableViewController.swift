//
//  HistoriesTableViewController.swift
//  Demo
//
//  Created by Ning Li on 4/18/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class HistoriesTableViewController: UITableViewController {
    
    var histories: [History]?

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if histories == nil {
            return 0
        }
        if section == 0 {
            return 1
        }
        return histories!.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        // Configure the cell...
        if (indexPath as NSIndexPath).section == 0 {
            cell.textLabel?.text = "Custodian: \(histories![(indexPath as NSIndexPath).section].custodian!)"
            cell.detailTextLabel?.text = "Location: \(histories![(indexPath as NSIndexPath).section].sortRoom!)"
            return cell
        }
        cell.textLabel?.text = "Custodian: \(histories![1 + (indexPath as NSIndexPath).row].custodian!)"
        cell.detailTextLabel?.text = "Location: \(histories![1 + (indexPath as NSIndexPath).row].sortRoom!)"
        return cell
    }
    
    // add title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current Custodian & Location"
        }
        return "Previous Custodian & Location"
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowHistoryDetails" && self.histories != nil {
            if let indexPath = tableView.indexPathForSelectedRow {
                let historyDetails = segue.destination as! HistoryDetailsTableView
                if (indexPath as NSIndexPath).section == 0 {
                    historyDetails.history = self.histories![0]
                }
                else {
                    historyDetails.history = self.histories![1 + (indexPath as NSIndexPath).row]
                }
            }
        }
    }

}
