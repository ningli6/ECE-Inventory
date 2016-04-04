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
    
    // hit HokieSPA
    let hokieSpa = "https://banweb.banner.vt.edu/ssomanager_prod/c/SSB"
    // pid
    var pid: String?
    // session id
    var jsessionid: String?
    // query url
    var url: String?
    // execute times
    var count: Int?
    
    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        let password = passwordTextField.text
        
        // check for nil
        if pid == "" || password == "" {
            let alert = UIAlertController(title: "Invalid username or password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
//        if self.jsessionid == nil {
//            self.count = 1
//            Alamofire.request(.GET, hokieSpa)
//                .responseJSON { response in
//                    // get jsessionid
//                    self.url = response.response?.URL!.absoluteString
//                    let begin = self.url!.rangeOfString("=")!.startIndex.advancedBy(1)
//                    let end = self.url!.rangeOfString("?")!.startIndex
//                    self.jsessionid = self.url!.substringWithRange(Range<String.Index>(start: begin, end: end))
//                    // post to form
//                    let mutableUrlRequest = NSMutableURLRequest(URL: response.response!.URL!)
//                    mutableUrlRequest.HTTPMethod = "POST"
//                    mutableUrlRequest.HTTPBody = "j_username=\(pid!)&j_password=\(password!)&_eventId_proceed=".dataUsingEncoding(NSUTF8StringEncoding)
//                    
//                    mutableUrlRequest.setValue("JSESSIONID=\(self.jsessionid!)", forHTTPHeaderField: "Cookie")
//                    mutableUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//                    mutableUrlRequest.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36", forHTTPHeaderField: "User-Agent")
//                    
//                    Alamofire.request(mutableUrlRequest).responseJSON { res in
//                        //handling the response
//                        let loginHTML = NSString(data: res.data!, encoding:NSUTF8StringEncoding)
//                        // this check is a reliable, maybe invalid in the future
//                        if loginHTML!.lowercaseString.containsString("invalid username or password") {
//                            let alert = UIAlertController(title: "Invalid username or password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//                            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
//                            self.presentViewController(alert, animated: true, completion: nil)
//                        } else {
//                            self.pid = pid
//                            self.performSegueWithIdentifier("LogInSucceeded", sender: nil)
//                        }
//                    }
//            }
//        } else {
//            count = count! + 1
//            let newURL = self.url!.substringToIndex(self.url!.endIndex.advancedBy(-1)) + String(count!)
//            let mutableUrlRequest = NSMutableURLRequest(URL: NSURL(string: newURL)!)
//            mutableUrlRequest.HTTPMethod = "POST"
//            mutableUrlRequest.HTTPBody = "j_username=\(pid!)&j_password=\(password!)&_eventId_proceed=".dataUsingEncoding(NSUTF8StringEncoding)
//            
//            mutableUrlRequest.setValue("JSESSIONID=\(self.jsessionid!)", forHTTPHeaderField: "Cookie")
//            mutableUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            mutableUrlRequest.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36", forHTTPHeaderField: "User-Agent")
//            
//            Alamofire.request(mutableUrlRequest).responseJSON { res in
//                //handling the response
//                let loginHTML = NSString(data: res.data!, encoding:NSUTF8StringEncoding)
//                // this check is a reliable, maybe invalid in the future
//                if loginHTML!.lowercaseString.containsString("invalid username or password") {
//                    let alert = UIAlertController(title: "Invalid username or password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                } else {
//                    self.pid = pid
//                    self.performSegueWithIdentifier("LogInSucceeded", sender: nil)
//                }
//            }
//        }
        self.pid = pid
        self.performSegueWithIdentifier("LogInSucceeded", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "LogInSucceeded") {
            let tabBarView = segue.destinationViewController as! UITabBarController
            let searchUsersView = tabBarView.viewControllers?.first as! SearchUsersViewController
            searchUsersView.pid = self.pid!
        }
    }
}

