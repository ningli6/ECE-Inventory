//
//  Request.swift
//  Demo
//
//  Created by Ning Li on 4/7/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation


class Request {
    // barcode
    var barcode: String?
    // sender
    var sender: String?
    // receiver
    var receiver: String?
    // status
    var status: String?
    // unix time
    var time: String?
    
    init(barcode: String, sender: String, receiver: String, status: NSNumber, time: String) {
        self.barcode = barcode
        self.sender = sender
        self.receiver = receiver
        if status == 0 {
            self.status = "Pending"
        } else if status == 1 {
            self.status = "Approved"
        } else {
            self.status = "Denied"
        }
        // adjust based on local time and UTC
        let timeStr = String(NSDate(timeIntervalSince1970: (Double(time)! - 14400)))
        self.time = timeStr.substringToIndex(timeStr.endIndex.advancedBy(-6))
    }
}
