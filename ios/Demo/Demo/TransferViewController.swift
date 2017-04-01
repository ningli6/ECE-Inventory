//
//  TransferViewController.swift
//  Demo
//
//  Created by Ning Li on 4/7/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import Alamofire
import SearchTextField

class TransferViewController: UIViewController {
    
    var currentOwner: String?    // currrent custodian
    var barcode: String?   // item barcode
    var receiver: String?  // receiver of the item
    
    let base_url = Shared.shared.base_url
    let transfer_url = "/api/transfers"
    let users_url = "/api/users"
    var receiverNameLabel: SearchTextField?
    
    @IBOutlet weak var transferButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var people:[String] = []
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        Alamofire.request(base_url + users_url).responseJSON(completionHandler: { response in
            if response.response?.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options:JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                    for person in json {
                        people.append(person["name"] as! String)
                    }
                    self.receiverNameLabel!.filterStrings(people)
                } catch {
                    print("Error with Json: \(error)")
                }
            }
        })
        receiverNameLabel = SearchTextField(frame: CGRect(x:view.frame.width/4, y: view.frame.height/4, width: view.frame.width/2,height: 40))
        receiverNameLabel!.startVisible = true
        receiverNameLabel!.borderStyle = UITextBorderStyle.roundedRect
        receiverNameLabel!.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        view.addSubview(receiverNameLabel!)
        // check whether this item was requested to be transfered
        if self.barcode != nil {
            Alamofire.request(base_url + transfer_url + "/\(barcode!)").responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data!, options:JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                        if json.count > 0 {
                            let alert = UIAlertController(title: "Ownership transfer requested!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.transferButton.isEnabled = false
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
    
    @IBAction func TransferRequest(_ sender: AnyObject) {
        if currentOwner == nil || currentOwner == "" || barcode == nil || barcode == "" {
            let alert = UIAlertController(title: "Invalid item barcode or owner name", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if receiverNameLabel?.text == nil || receiverNameLabel?.text == "" {
            let alert = UIAlertController(title: "Invalid receiver name", message: "Please type lastname, firstname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.receiver = receiverNameLabel?.text
        // post parameters
        let postParams = [
            "ptag": self.barcode as AnyObject,
            "sender": self.currentOwner as AnyObject,
            "receiver": self.receiver as AnyObject
        ]
        Alamofire.request(base_url + transfer_url, method:.post, parameters: postParams).responseJSON { response in
            // successful post
            if response.response?.statusCode == 201 {
                let alert = UIAlertController(title: "Transfer Request Sent!", message: "The inventory administrator will review this transfer request.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: self.unwindTowardsItemDetailsView))
                self.present(alert, animated: true, completion: nil)
                return
            }
            // server returns error
            if response.response?.statusCode == 400 {
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options:JSONSerialization.ReadingOptions()) as! [String: AnyObject]
                    let error = json["Message"] as! String
                    let alert = UIAlertController(title: "Transfer Request Denied!", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } catch {
                    print("Error with Json: \(error)")
                }
            }
            // other results
            let alert = UIAlertController(title: "Transfer Request Failed!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }

    // MARK: - Navigation
    func unwindTowardsItemDetailsView(_ action : UIAlertAction) {
        performSegue(withIdentifier: "FinishTransferRequest", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
