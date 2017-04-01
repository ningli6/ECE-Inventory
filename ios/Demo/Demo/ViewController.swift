//
//  ViewController.swift
//  Demo
//
//  Created by Ning Li on 2/10/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // pid
    var pid: String?
    // query url
    var url: String?
    // execute times
    var count: Int?
    let base_url: String = Shared.shared.base_url
    var user: User?
    
    @IBOutlet weak var userIDTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
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
    
    // navigation
    @IBAction func tryToLogInAdmin() {
        // hit hokie spa
        // hardcoded credentials
        let pid = userIDTextField.text

        // check for nil
        if pid == "" {
            let alert = UIAlertController(title: "Invalid username or password", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.pid = pid
        retriveData()
        
        
        
        //self.performSegue(withIdentifier: "LogInSucceeded", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Login") {
            let tabBarView = segue.destination as! UITabBarController
            let itemsNavView = tabBarView.viewControllers?[0] as! UINavigationController
            let itemsTableView = itemsNavView.viewControllers[0] as! ItemsTableViewController
            let searchUsersView = tabBarView.viewControllers?[2] as! SearchUsersViewController
            searchUsersView.pid = self.pid!
            itemsTableView.pid = self.pid!
            itemsTableView.user = self.user!
            
        }
    }
    func retriveData() {
        let pid = self.pid
        let query = base_url + "/api/UsersByPID/" + pid!.replacingOccurrences(of: " ", with: "%20")
        let requestURL: URL = URL(string: query)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let session = URLSession.shared
        
        // create alert
        let loadingAlert = UIAlertController(title: "Searching", message: "\n\n\n\n", preferredStyle: .alert)
        loadingAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor.black
        indicator.frame = loadingAlert.view.bounds
        indicator.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        indicator.startAnimating()
        loadingAlert.view.addSubview(indicator)
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            
            DispatchQueue.main.async(execute: {
                loadingAlert.dismiss(animated: true, completion: { () -> Void in
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        do
                        {
                            self.user = User()
                            let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                            if (json.isEmpty) {
                                // alert
                                let alert = UIAlertController(title: "User was not found", message: "User with pid \(pid!) does not exist", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
                                alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.default, handler: { (a: UIAlertAction) in
                                    
                                    DispatchQueue.main.async(execute: {
                                        self.performSegue(withIdentifier: "Login", sender: nil)
                                    })
                                }))
                                self.present(alert, animated: true, completion: nil)
                                return
                                
                            } else {
                                self.user!.pid = pid
                                for item in json {
                                    // huge ugly init
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
                                    
                                    self.user!.items!.append(Item(owner: owner, orgnCode: orgnCode, orgnTitle: orgnTitle, room: room, bldg: bldg, sortRoom: sortRoom, ptag: ptag, manufacturer: manufacturer, model: model, sn: sn, description: description, custodian: custodian, po: po, acqDate: acqDate, amt: amt, ownership: ownership, schevYear: schevYear, tagType: tagType, assetType: assetType, atypTitle: atypTitle, condition: condition, lastInvDate: lastInvDate, designation: designation))
                                }
                            }
                            if (self.user != nil) {
                                DispatchQueue.main.async(execute: {
                                        self.performSegue(withIdentifier: "Login", sender: nil)
                                })
                            }
                            
                        } catch {
                            print("Error with Json: \(error)")
                            return
                        }
                    } else {
                        DispatchQueue.main.async(execute: {
                            // alert
                            let alert = UIAlertController(title: "User not found", message: "Server returns \(statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                })
            })
        })
        task.resume()
        self.present(loadingAlert, animated: true, completion: nil)
        
    }
    func Proceed() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "Login", sender: nil)
        })
    }

}

