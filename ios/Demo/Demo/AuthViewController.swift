//
//  AuthViewController.swift
//  ECEInventory
//
//  Created by Weijia on 3/23/17.
//  Copyright © 2017 Virginia Tech. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDelegate {
    let loginURL2: String = "https://eceinventory.ece.vt.edu"
    let loginURL1: String = "https://vteceinventory.azurewebsites.net/authentication/ProduceCookie"
    let loginURL: String = "https://vteceinventory.azurewebsites.net/authentication/LogOn"
    
    var requestBackup: URLRequest?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authWebView: UIWebView!
    
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let url: URL? = URL(string: loginURL)
        let request: URLRequest = URLRequest(url: url!)
        requestBackup = URLRequest(url: URL(string: loginURL1)!)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
        authWebView.loadRequest(request)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("checkCookies"), userInfo: nil, repeats: true)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCookies() {
        let cookies: [HTTPCookie]? = HTTPCookieStorage.shared.cookies
        for cookie in cookies! {
            if cookie.name == "pep3" && cookie.value == "pep3=pep3" {
                self.performSegue(withIdentifier: "SetPID", sender: "cookies")
                timer!.invalidate()
                
            }
        }
        
        
    }
    func webView(webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        //Do whatever you want to do.
        
        return true
    }
    
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge){
        print("In willSendRequestForAuthenticationChallenge..");
        challenge.sender!.use(URLCredential(trust:challenge.protectionSpace.serverTrust!),for: challenge)
        challenge.sender!.continueWithoutCredential(for: challenge)

    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
        authWebView.loadRequest(requestBackup!)
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(webView.request)
        activityIndicator.startAnimating()
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
