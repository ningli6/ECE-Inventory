//
//  ItemDetailsViewController.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UITableViewController {
    
    var connectionString =  "DefaultEndpointsProtocol=https;AccountName=eceinventory;AccountKey=rzuspKSY65DcSH6EzOFMJrL6067TXKUP7+3iGX+eCNMlDkUJgngPe2irrrMGMZli7RaIlGFVdWmB9GsqYv9kbQ=="
    
    var item: Item?
    var bloblist: AZSBlobResultSegment?
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        if (cell == self.imageDetailCell) {
            /* Download the image from azure cloud storage if exists */
            // Create a storage account object from a connection string.
            let account = AZSCloudStorageAccount(fromConnectionString:connectionString)

            // Create a blob service client object.
            let blobClient: AZSCloudBlobClient = account.getBlobClient()

            // Create a local container object.
            let blobContainer: AZSCloudBlobContainer = blobClient.containerReferenceFromName(self.item!.ptag!)
            
            // Create container if not exists
            blobContainer.createContainerIfNotExistsWithCompletionHandler({ (cerror: NSError?, exists: Bool) -> Void in
                // list blobs in a container
                blobContainer.listBlobsSegmentedWithContinuationToken(nil, prefix: nil, useFlatBlobListing: true, blobListingDetails: AZSBlobListingDetails.All, maxResults: -1, completionHandler: { (error: NSError?, results: AZSBlobResultSegment?) -> Void in
                    if (error != nil) {
                        print(error)
                        print("Error downloading blobs list")
                    } else {
                        self.bloblist = results
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("GallerySegue", sender: nil)
                        })
                    }
                })
            })


            // Create a local blob object
            // for now just use hardcoded name image for each item
//            let imageName = "image"
//            let blob: AZSCloudBlockBlob = blobContainer.blockBlobReferenceFromName(imageName as String)
//
//            // Download blob
//            blob.downloadToDataWithCompletionHandler({ (error: NSError?, data: NSData?) -> Void in
//                if ((error) != nil) {
////                    print(error)
//                    // image not exists in the cloud storage, clear ram
//                    self.image = nil
//                } else {
//                    self.image = UIImage(data:data!,scale:1.0)
//                }
//                dispatch_async(dispatch_get_main_queue(), {
//                    // code here
//                    self.performSegueWithIdentifier("CheckImage", sender: nil)
//                })
//            })
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
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if segue.identifier == "CheckImage" {
//            let itemImageView = segue.destinationViewController as! ItemImageViewController
//            itemImageView.barcode = self.item?.ptag
////            itemImageView.image = self.image;
//        }
//        
        if segue.identifier == "GallerySegue" {
            let imageGalleryView = segue.destinationViewController as! ImagesCollectionViewController
            imageGalleryView.bloblist = self.bloblist;
            imageGalleryView.barcode = self.item?.ptag;
        }
    }

}
