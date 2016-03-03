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
    
    var images: [UIImage]?
    var barcode: String?
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddImage" {
            let addImageView = segue.destinationViewController as! AddImageViewController
            addImageView.barcode = self.barcode;
        }
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
        // Download blob
        bloblist?.blobs![indexPath.row].downloadToDataWithCompletionHandler({ (error: NSError?, data: NSData?) -> Void in
            if ((error) != nil) {
                print("Error with downloading image!")
                // image not exists in the cloud storage, clear ram
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView.image = UIImage(data:data!,scale:1.0)
                })
            }
        })
        
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

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

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

}
