//
//  ImagesCollectionViewController.swift
//  Demo
//
//  Created by Ning Li on 3/2/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCell"

class ImagesCollectionViewController: UICollectionViewController {
    
    // selected image
    var selectedImage: UIImage?
    // blob name for the selected image
    var selectedBlobName: String?
    // uploading date for the image
    var uploadingDate: NSDate?
    // notes of the selected image
    var notesOfImage: String?
    // barcode of the item (container name), set by previous view
    var barcode: String?
    // blob list, set by previous view
    var bloblist: AZSBlobResultSegment?
    
    var connectionString =  "DefaultEndpointsProtocol=https;AccountName=eceinventory;AccountKey=rzuspKSY65DcSH6EzOFMJrL6067TXKUP7+3iGX+eCNMlDkUJgngPe2irrrMGMZli7RaIlGFVdWmB9GsqYv9kbQ=="

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadingFromAddNotesViewController(segue: UIStoryboardSegue) {
        /* Download the image from azure cloud storage if exists */
        // Create a storage account object from a connection string.
        let account = AZSCloudStorageAccount(fromConnectionString:connectionString)
        
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient = account.getBlobClient()
        
        // Create a local container object.
        let blobContainer: AZSCloudBlobContainer = blobClient.containerReferenceFromName(self.barcode!)
        
        // list blobs in a container
        blobContainer.listBlobsSegmentedWithContinuationToken(nil, prefix: nil, useFlatBlobListing: true, blobListingDetails: AZSBlobListingDetails.All, maxResults: -1, completionHandler: { (error: NSError?, results: AZSBlobResultSegment?) -> Void in
            if (error != nil) {
                NSLog("Error downloading blobs list")
            } else {
                self.bloblist = results
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
            }
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bloblist == nil ? 0 : bloblist!.blobs!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        // Configure the cell
        // Download blob according to the blob list
        bloblist?.blobs![bloblist!.blobs!.count - 1 - indexPath.row].downloadToDataWithCompletionHandler({ (error: NSError?, data: NSData?) -> Void in
            if ((error) != nil) {
                print("Error with downloading image!")
                // image not exists in the cloud storage, clear ram
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView.image = UIImage(data:data!,scale:1.0)
                })
            }
        })
        cell.notesId = bloblist?.blobs![bloblist!.blobs!.count - 1 - indexPath.row].blobName
        // keep track of the uploading date, date comes from the system
        cell.uploadingDate = NSDate(timeIntervalSince1970: Double(cell.notesId!)! - 18000)
        
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        self.selectedImage = cell.imageView.image
        self.uploadingDate = cell.uploadingDate
        self.selectedBlobName = cell.notesId
        
        // Create a storage account object from a connection string.
        let account = AZSCloudStorageAccount(fromConnectionString:connectionString)
        
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient = account.getBlobClient()
        
        // Create a local container object.
        let blobContainer: AZSCloudBlobContainer = blobClient.containerReferenceFromName(self.barcode! + "text")
        
        // list blobs in a container
        let textBlob: AZSCloudBlob = blobContainer.blockBlobReferenceFromName(cell.notesId!)
        
        // Download blob
        textBlob.downloadToTextWithCompletionHandler { (error: NSError?, results: String?) -> Void in
            if error != nil {
                print("Error downloading text notes")
            } else {
                self.notesOfImage = results
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("ShowImageDetails", sender: nil)
                })
            }
        }
        return true
    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddImage" {
            let addImageView = segue.destinationViewController as! AddImageViewController
            addImageView.barcode = self.barcode;
        }
        
        if segue.identifier == "ShowImageDetails" {
            let imageDetailsView = segue.destinationViewController as! ImageDetailsViewController
            imageDetailsView.container = self.barcode
            imageDetailsView.blobName = self.selectedBlobName
            imageDetailsView.image = self.selectedImage
            imageDetailsView.notes = self.notesOfImage
            imageDetailsView.uploadingDate = self.uploadingDate
        }
    }
}
