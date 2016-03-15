//
//  ScanTabViewController.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class ScanTabViewController: UIViewController {
    
    // base url for the backend
    let base_url = "http://eceinventory.azurewebsites.net"
    // searched item
    var item: Item?

    @IBOutlet weak var barcodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
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
    
    
    @IBAction func searchBarcode(sender: AnyObject) {
        // http connection and get the data
        if (barcodeTextField.text == "") {
            // alert
            let alert = UIAlertController(title: "Empty Input", message: "Please enter barcode.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let barcode = barcodeTextField.text
        let query = base_url + "/api/items/barcode/" + barcode!
        let requestURL: NSURL = NSURL(string: query)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions()) as! [[String: AnyObject]]
                        if (json.isEmpty) {
                            // alert
                            let alert = UIAlertController(title: "Item not found", message: "Item with barcode \(barcode!) does not exist in the inventory", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                        }
                        for item in json {
                            // huge ugly init
                            let id = item["Id"] as! Int
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
                            
                            self.item = Item(id: id, owner: owner, orgnCode: orgnCode, orgnTitle: orgnTitle, room: room, bldg: bldg, sortRoom: sortRoom, ptag: ptag, manufacturer: manufacturer, model: model, sn: sn, description: description, custodian: custodian, po: po, acqDate: acqDate, amt: amt, ownership: ownership, schevYear: schevYear, tagType: tagType, assetType: assetType, atypTitle: atypTitle, condition: condition, lastInvDate: lastInvDate, designation: designation)
                        }
                        if self.item != nil {
                            self.performSegueWithIdentifier("BarcodeFound", sender: nil)
                        }
                    } catch {
                        print("Error with Json: \(error)")
                        return
                    }
                } else {
                    // alert
                    let alert = UIAlertController(title: "Item not found", message: "Item with barcode \(barcode!) does not exist in the inventory", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
            })
        }
        task.resume()
    }
    
    // MARK: - Navigation
    @IBAction func cancelFromBarcodeScannerViewToScanTabView(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelFromScannedItemDetailsViewToScanTabView(segue: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "BarcodeFound") {
            let navView = segue.destinationViewController as! UINavigationController
            let scannedItemDetailsView = navView.viewControllers.first as! ScannedItemDetailsViewController
            scannedItemDetailsView.item = self.item
        }
    }

}
