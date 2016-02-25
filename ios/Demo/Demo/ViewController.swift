//
//  ViewController.swift
//  Demo
//
//  Created by Ning Li on 2/10/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // hardcoded logins
    var logins:[String:String] = ["admin":"admin"]
    
    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

    // navigation
    @IBAction func tryToLogInAdmin() {
        let userId = userIDTextField.text
        let password = passwordTextField.text
//        if logins[userId!] == password! {
        if true {
            performSegueWithIdentifier("LogInSucceeded", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "The ID and password you entered don't match.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

