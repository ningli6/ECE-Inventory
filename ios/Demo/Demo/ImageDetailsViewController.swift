//
//  ImageDetailsViewController.swift
//  Demo
//
//  Created by Ning Li on 3/3/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    var connectionString =  "DefaultEndpointsProtocol=https;AccountName=inventory6897;AccountKey=u55YZhE8dvZHjkGkwwrOyBtQa86mFrIBtp+tJbnL/5B554TXMAq0WCyULPKWu5z1txc60MtvBC0nH3sYn/j09A=="
    
    // container name, set by previous view
    var container: String?
    // blob name
    var blobName: String?
    // image displayed in the view
    var image: UIImage?
    // notes dispalyed in the view
    var notes: String?
    // uploading date
    var uploadingDate: NSDate?

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var dateLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up elements displayed in the view
        self.imageView.image = self.image
        self.notesTextView.text = self.notes
        let timeStr = String(self.uploadingDate!)
        self.dateLabelView.text = timeStr.substringToIndex(timeStr.endIndex.advancedBy(-6))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteImage(sender: AnyObject) {
        /* Delete the image from azure cloud storage if exists */
        // Create a storage account object from a connection string.
        let account = AZSCloudStorageAccount(fromConnectionString:connectionString)
        
        // Create a blob service client object.
        let blobClient: AZSCloudBlobClient = account.getBlobClient()
        
        // Create a local container object.
        let blobContainer: AZSCloudBlobContainer = blobClient.containerReferenceFromName(self.container!)
        
        // Create a local blob object
        let blobObject: AZSCloudBlockBlob = blobContainer.blockBlobReferenceFromName(self.blobName!)
        
        blobObject.deleteWithCompletionHandler { (error: NSError?) -> Void in
            if (error != nil) {
                print("Error deleting image")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = nil
                    self.notesTextView.text = nil
                    let alert = UIAlertController(title: "Image deleted!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(
                        UIAlertAction(
                            title: "Okay",
                            style: UIAlertActionStyle.Default,
                            handler: { (action: UIAlertAction? ) -> Void in
                                self.performSegueWithIdentifier("FinishDeleting", sender: nil)
                            }
                        )
                    )
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
        
        // Create a local container object.
        let blobTextContainer: AZSCloudBlobContainer = blobClient.containerReferenceFromName(self.container! + "text")
        
        // Create a local blob object
        let blobTextObject: AZSCloudBlockBlob = blobTextContainer.blockBlobReferenceFromName(self.blobName!)
        
        blobTextObject.deleteWithCompletionHandler { (error: NSError?) -> Void in
            if (error != nil) {
                print("Error deleting image notes")
            }
        }

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
