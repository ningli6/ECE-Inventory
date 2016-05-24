//
//  TransferViewController.swift
//  Demo
//
//  Created by Ning Li on 4/7/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import Alamofire

class TransferViewController: UIViewController {
    
    var currentOwner: String?    // currrent custodian
    var barcode: String?   // item barcode
    var receiver: String?  // receiver of the item
    
    let base_url = "http://40.121.81.36"
    let transfer_url = "/api/transfers"

    @IBOutlet weak var receiverNameLable: UITextField!
    
    @IBOutlet weak var transferButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // check whether this item was requested to be transfered
        if self.barcode != nil {
            Alamofire.request(.GET, base_url + transfer_url + "/\(barcode!)").responseJSON(completionHandler: { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print("Response data: \(NSString(data: response.data!, encoding: NSUTF8StringEncoding)!)")     // server data
//                print(response.result)   // result of response serialization
                if response.response?.statusCode == 200 {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options:NSJSONReadingOptions()) as! [[String: AnyObject]]
                        if json.count > 0 {
                            let alert = UIAlertController(title: "Ownership transfer requested!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            self.transferButton.enabled = false
                        }
                    } catch {
                        print("Error with Json: \(error)")
                    }
                }
            })
        }

    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TransferRequest(sender: AnyObject) {
        if currentOwner == nil || currentOwner == "" || barcode == nil || barcode == "" {
            let alert = UIAlertController(title: "Invalid item barcode or owner name", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if receiverNameLable.text == nil || receiverNameLable.text == "" {
            let alert = UIAlertController(title: "Invalid receiver name", message: "Please type lastname, firstname", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.receiver = receiverNameLable.text
        // post parameters
        let postParams = [
            "ptag": self.barcode as! AnyObject,
            "sender": self.currentOwner as! AnyObject,
            "receiver": self.receiver as! AnyObject
        ]
        Alamofire.request(.POST, base_url + transfer_url, parameters: postParams).responseJSON { response in
            // successful post
            if response.response?.statusCode == 201 {
                let alert = UIAlertController(title: "Transfer Request Sent!", message: "The inventory administrator will review this transfer request.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: self.unwindTowardsItemDetailsView))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            // server returns error
            if response.response?.statusCode == 400 {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options:NSJSONReadingOptions()) as! [String: AnyObject]
                    let error = json["Message"] as! String
                    let alert = UIAlertController(title: "Transfer Request Denied!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                } catch {
                    print("Error with Json: \(error)")
                }
            }
            // other results
            let alert = UIAlertController(title: "Transfer Request Failed!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }

    // MARK: - Navigation
    func unwindTowardsItemDetailsView(action : UIAlertAction) {
        performSegueWithIdentifier("FinishTransferRequest", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
