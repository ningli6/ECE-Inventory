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
    var uploadingDate: Date?
    // notes of the selected image
    var notesOfImage: String?
    // barcode of the item (container name), set by previous view
    var barcode: String?
    // blob list, set by previous view
    var bloblist: AZSBlobResultSegment?
    // blob array, divided by time
    var blobBySection: [[AZSCloudBlob]]?
    // timestamp array
    var sectionTimeStamp: [String]?
    
    var connectionString =  "DefaultEndpointsProtocol=https;AccountName=inventory6897;AccountKey=u55YZhE8dvZHjkGkwwrOyBtQa86mFrIBtp+tJbnL/5B554TXMAq0WCyULPKWu5z1txc60MtvBC0nH3sYn/j09A=="

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        divideBlobByTime(self.bloblist)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func divideBlobByTime(_ bloblist: AZSBlobResultSegment?) -> Void {
        self.blobBySection = nil
        self.sectionTimeStamp = nil
        if (bloblist != nil && bloblist!.blobs!.count > 0) {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            
            self.blobBySection = [[AZSCloudBlob]]()
            self.sectionTimeStamp = [String]()
            var lastDate: Date?
            var index: Int?
            for blob in bloblist!.blobs! {
                let newDate = Date(timeIntervalSince1970: Double((blob as AnyObject).blobName)! - 18000)
                if lastDate == nil {
                    self.blobBySection?.append([AZSCloudBlob]())
                    self.blobBySection![0].append(blob as! AZSCloudBlob)
                    self.sectionTimeStamp?.append(formatter.string(from: newDate))
                    lastDate = newDate
                    index = 0
                } else if (Calendar.current as NSCalendar).compare(newDate, to: lastDate!,
                    toUnitGranularity: NSCalendar.Unit.day) == ComparisonResult.orderedSame {
                        self.blobBySection![index!].append(blob as! AZSCloudBlob)
                } else {
                    self.blobBySection?.append([AZSCloudBlob]())
                    index = index! + 1
                    self.blobBySection![index!].append(blob as! AZSCloudBlob)
                    lastDate = newDate
                    self.sectionTimeStamp?.append(formatter.string(from: newDate))
                }
            }
        }
    }
    
    @IBAction func uploadingFromAddNotesViewController(_ segue: UIStoryboardSegue) {
        print("Reload collection view!")
        
        /* Download the image from azure cloud storage if exists */
        // Create a storage account object from a connection string.
        let account = AZSCloudStorageAccount(fromConnectionString:connectionString)
        
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient = account!.getBlobClient()
        
        // Create a local container object.
        let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName: self.barcode!)
        
        // list blobs in a container
        blobContainer.listBlobsSegmented(with: nil, prefix: nil, useFlatBlobListing: true, blobListingDetails: AZSBlobListingDetails.all, maxResults: -1, completionHandler: { (error: NSError?, results: AZSBlobResultSegment?) -> Void in
            if (error != nil) {
                NSLog("Error downloading blobs list")
            } else {
                self.bloblist = results
                self.divideBlobByTime(self.bloblist)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
            }
        } as! (Error?, AZSBlobResultSegment?) -> Void)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.blobBySection == nil ? 0 : self.blobBySection!.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.blobBySection![self.blobBySection!.count - 1 - section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        // Configure the cell
        // Download blob according to the blob list
        let indexSection = self.blobBySection!.count - 1 - (indexPath as NSIndexPath).section
        let indexRow = self.blobBySection![indexSection].count - 1 - (indexPath as NSIndexPath).row
        
        self.blobBySection![indexSection][indexRow].downloadToData(completionHandler: { (error: Error?, data: Data?) -> Void in
            if ((error) != nil) {
                print("Error with downloading image!")
                // image not exists in the cloud storage, clear ram
            } else {
                DispatchQueue.main.async(execute: {
                    cell.imageView.image = UIImage(data:data!,scale:1.0)
                })
            }
        })
        
        cell.notesId = blobBySection![indexSection][indexRow].blobName
        // keep track of the uploading date, date comes from the system
        cell.uploadingDate = Date(timeIntervalSince1970: Double(cell.notesId!)! - 18000)
        
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
            //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageCollectionHeaderView", for: indexPath) as! ImageCollectionReusableView
            let sections = self.sectionTimeStamp?.count
            headerView.headerLabel.text = self.sectionTimeStamp![sections! - 1 - (indexPath as NSIndexPath).section]
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        self.selectedImage = cell.imageView.image
        self.uploadingDate = cell.uploadingDate as Date?
        self.selectedBlobName = cell.notesId
        
        // Create a storage account object from a connection string.
        let account = AZSCloudStorageAccount(fromConnectionString:connectionString)
        
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient = account!.getBlobClient()
        
        // Create a local container object.
        let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName: self.barcode! + "text")
        
        // list blobs in a container
        let textBlob: AZSCloudBlob = blobContainer.blockBlobReference(fromName: cell.notesId!)
        
        // Download blob
 
        textBlob.downloadToText { (error: Error?, results: String?) -> Void in
            if error != nil {
                print("Error downloading text notes")
            } else {
                self.notesOfImage = results
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "ShowImageDetails", sender: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddImage" {
            let addImageView = segue.destination as! AddImageViewController
            addImageView.barcode = self.barcode;
        }
        
        if segue.identifier == "ShowImageDetails" {
            let imageDetailsView = segue.destination as! ImageDetailsViewController
            imageDetailsView.container = self.barcode
            imageDetailsView.blobName = self.selectedBlobName
            imageDetailsView.image = self.selectedImage
            imageDetailsView.notes = self.notesOfImage
            imageDetailsView.uploadingDate = self.uploadingDate
        }
    }
}
