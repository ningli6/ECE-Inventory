//
//  History.swift
//  Demo
//
//  Created by Ning Li on 4/18/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation

class History {
    
    var barcode: String?
    var custodian: String?
    
    var bldg: String?
    var room: String?
    var sortRoom: String?

    var time: String?
    
    init(barcode: String, custodian: String, bldg: String, room: String, sortRoom: String, time: String) {
        self.barcode = barcode
        self.custodian = custodian
        self.bldg = bldg
        self.room = room
        self.sortRoom = sortRoom
        // adjust based on local time and UTC
        let timeStr = String(describing: Date(timeIntervalSince1970: (Double(time)! - 14400)))
        self.time = timeStr.substring(to: timeStr.characters.index(timeStr.endIndex, offsetBy: -6))
    }
    
}
