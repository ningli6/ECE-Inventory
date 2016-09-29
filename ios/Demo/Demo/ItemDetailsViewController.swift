//
//  ItemDetailsViewController.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import Alamofire

class ItemDetailsViewController: UITableViewController {
    
    var connectionString =  "DefaultEndpointsProtocol=https;AccountName=inventory6897;AccountKey=u55YZhE8dvZHjkGkwwrOyBtQa86mFrIBtp+tJbnL/5B554TXMAq0WCyULPKWu5z1txc60MtvBC0nH3sYn/j09A=="
    
    let base_url = "http://40.121.81.36"
    let query_url = "/api/histories/"
    
    var item: Item?
    var bloblist: AZSBlobResultSegment?
    // what is my source view controller
    var returnToSearchTab: Bool?
    
    // histories
    var histories: [History]?
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    @IBOutlet weak var itemOrgnTitleLabel: UILabel!
    
    @IBOutlet weak var itemLocationLabel: UILabel!
    
    @IBOutlet weak var itemBarcodeLabel: UILabel!
    
    @IBOutlet weak var itemManufacturerLabel: UILabel!
    
    @IBOutlet weak var itemModelLabel: UILabel!
    
    @IBOutlet weak var itemCustodianLabel: UILabel!
    
    @IBOutlet weak var itemAcqDateLabel: UILabel!
    
    @IBOutlet weak var itemAMTLabel: UILabel!
    
    @IBOutlet weak var itemOwnershipLabel: UILabel!
    
    @IBOutlet weak var itemConditionLabel: UILabel!
    
    @IBOutlet weak var itemLastInvDateLabel: UILabel!
    
    @IBOutlet weak var itemDesignationLabel: UILabel!
    
    @IBOutlet weak var imageDetailCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate item information
        itemDescriptionLabel.text = item?.description
        itemOrgnTitleLabel.text = item?.orgnTitle
        itemLocationLabel.text = item?.sortRoom
        itemBarcodeLabel.text = item?.ptag
        itemManufacturerLabel.text = item?.manufacturer
        itemModelLabel.text = item?.model
        itemCustodianLabel.text = item?.custodian
        itemAcqDateLabel.text = item?.acqDate
        itemAMTLabel.text = item?.amt
        itemOwnershipLabel.text = item?.ownership
        itemConditionLabel.text = item?.condition
        itemLastInvDateLabel.text = item?.lastInvDate
        itemDesignationLabel.text = item?.designation
        
        // show the unwind button if navigate from search tab
        if self.returnToSearchTab! {
            let done = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(ItemDetailsViewController.unwindTowardsSearchTab))
            self.navigationItem.rightBarButtonItem = done
            self.navigationItem.rightBarButtonItem!.tintColor = UIColor.white
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.histories = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        if (cell == self.imageDetailCell) {
            /* Download the image from azure cloud storage if exists */
            // Create a storage account object from a connection string.
            let account = AZSCloudStorageAccount(fromConnectionString:connectionString)

            // Create a blob service client object.
            let blobClient: AZSCloudBlobClient = account!.getBlobClient()

            // Create a local container object.
            let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName: self.item!.ptag!)
            
            // Create container if not exists
            blobContainer.createContainerIfNotExists(completionHandler: { (cerror: NSError?, exists: Bool) -> Void in
                // list blobs in a container
                blobContainer.listBlobsSegmented(with: nil, prefix: nil, useFlatBlobListing: true, blobListingDetails: AZSBlobListingDetails.all, maxResults: -1, completionHandler: { (error: NSError?, results: AZSBlobResultSegment?) -> Void in
                    if (error != nil) {
                        print(error)
                        print("Error downloading blobs list")
                    } else {
                        self.bloblist = results
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "GallerySegue", sender: nil)
                        })
                    }
                } as! (Error?, AZSBlobResultSegment?) -> Void)
            } as! (Error?, Bool) -> Void)
        }
        
        // histories column is selected
        if cell?.textLabel?.text == "Ownership & Location Histories" {
            Alamofire.request(.GET, base_url + query_url + "/\(self.item!.ptag!)").responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data!, options:JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                        self.histories?.removeAll()
                        for h in json {
                            let bldg = h["Bldg"] as! String
                            let room = h["Room"] as! String
                            let sortRoom = h["SortRoom"] as! String
                            let barcode = h["Ptag"] as! String
                            let custodian = h["Custodian"] as! String
                            var time = h["Time"] as! String
                            time = time.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            self.histories?.append(History(barcode: barcode, custodian: custodian, bldg: bldg, room: room, sortRoom: sortRoom, time: time))
                        }
                        self.performSegue(withIdentifier: "ShowHistories", sender: nil)
                    } catch {
                        print("Error with Json: \(error)")
                    }
                }
            })
        }
    }

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


    // MARK: - Navigation
    
    @IBAction func unwindFromTransferRequest (_ segue: UIStoryboardSegue) {
        
    }
    
    func unwindTowardsSearchTab() {
        performSegue(withIdentifier: "ReturnToSearchTab", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GallerySegue" {
            let imageGalleryView = segue.destination as! ImagesCollectionViewController
            imageGalleryView.bloblist = self.bloblist;
            imageGalleryView.barcode = self.item?.ptag;
        }
        if segue.identifier == "TransferOwnership" {
            let transferRequestView = segue.destination as! TransferViewController
            transferRequestView.barcode = item?.ptag
            transferRequestView.currentOwner = item?.custodian
        }
        if segue.identifier == "ShowHistories" {
            let historiesView = segue.destination as! HistoriesTableViewController
            historiesView.histories = self.histories
        }
    }

}
