//
//  BarcodeScannerViewController.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // searched item
    var item: Item?
    let base_url = "http://40.121.81.36"
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeQRCode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                let barcode = metadataObj.stringValue
                
                // search through database
                let query = base_url + "/api/items/\(barcode)"
                let requestURL: URL = URL(string: query)!
                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
                let session = URLSession.shared
                let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
                    (data, response, error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        let httpResponse = response as! HTTPURLResponse
                        let statusCode = httpResponse.statusCode

                        if (statusCode == 200) {
                            do{
                                let jsonData = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                                if (jsonData.isEmpty) {
                                    // alert
                                    let alert = UIAlertController(title: "Item not found", message: "Item with barcdoe \(barcode) does not exist", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: {(UIAlertAction) -> Void in
                                            self.captureSession?.startRunning()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    let json = jsonData[0]
                                    // huge ugly init
                                    let owner = json["Owner"] is NSNull ? "" : json["Owner"] as! String
                                    let orgnCode = json["OrgnCode"] is NSNull ? "" : json["OrgnCode"] as! String
                                    let orgnTitle = json["OrgnTitle"] is NSNull ? "" : json["OrgnTitle"] as! String
                                    let room = json["Room"] is NSNull ? "" : json["Room"] as! String
                                    let bldg = json["Bldg"] is NSNull ? "" : json["Bldg"] as! String
                                    let sortRoom = json["SortRoom"] is NSNull ? "" : json["SortRoom"] as! String
                                    let ptag = json["Ptag"] is NSNull ? "" : json["Ptag"] as! String
                                    let manufacturer = json["Manufacturer"] is NSNull ? "" : json["Manufacturer"] as! String
                                    let model = json["Model"] is NSNull ? "" : json["Model"] as! String
                                    let sn = json["SN"] is NSNull ? "" : json["SN"] as! String
                                    let description = json["Description"] is NSNull ? "" : json["Description"] as! String
                                    let custodian = json["Custodian"] is NSNull ? "" : json["Custodian"] as! String
                                    let po = json["PO"] is NSNull ? "" : json["PO"] as! String
                                    let acqDate = json["AcqDate"] is NSNull ? "" : json["AcqDate"] as! String
                                    let amt = json["Amt"] is NSNull ? "" : json["Amt"] as! String
                                    let ownership = json["Ownership"] is NSNull ? "" : json["Ownership"] as! String
                                    let schevYear = json["SchevYear"] is NSNull ? "" : json["SchevYear"] as! String
                                    let tagType = json["TagType"] is NSNull ? "" : json["TagType"] as! String
                                    let assetType = json["AssetType"] is NSNull ? "" : json["AssetType"] as! String
                                    let atypTitle = json["AtypTitle"] is NSNull ? "" : json["AtypTitle"] as! String
                                    let condition = json["Condition"] is NSNull ? "" : json["Condition"] as! String
                                    let lastInvDate = json["LastInvDate"] is NSNull ? "" : json["LastInvDate"] as! String
                                    let designation = json["Designation"] is NSNull ? "" : json["Designation"] as! String
                                    self.item = Item(owner: owner, orgnCode: orgnCode, orgnTitle: orgnTitle, room: room, bldg: bldg, sortRoom: sortRoom, ptag: ptag, manufacturer: manufacturer, model: model, sn: sn, description: description, custodian: custodian, po: po, acqDate: acqDate, amt: amt, ownership: ownership, schevYear: schevYear, tagType: tagType, assetType: assetType, atypTitle: atypTitle, condition: condition, lastInvDate: lastInvDate, designation: designation)
                                    // perform segue
                                    self.performSegue(withIdentifier: "ScanSuccess", sender: nil)
                                }
                            } catch {
                                print("Error with Json: \(error)")
                            }
                        } else {
                            // alert
                            let alert = UIAlertController(title: "Item not found", message: "Server returns \(statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: {(UIAlertAction) -> Void in
                                    self.captureSession?.startRunning()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }) 
                task.resume()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func didMove(toParentViewController parent: UIViewController?) {
        // keep capture session running
        if self.captureSession != nil && !self.captureSession!.isRunning {
            self.captureSession?.startRunning()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ScanSuccess") {
            let itemDetailsView = segue.destination as! ItemDetailsViewController
            itemDetailsView.item = self.item
            itemDetailsView.returnToSearchTab = true
        }
    }
    
}
