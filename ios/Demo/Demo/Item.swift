//
//  Item.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation


class Item {
    var name: String
    var barcode: String = "0123456789"
    var location: String = "Virginia Tech"
    var owner: String = "Virginia Tech"
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, barcode: String) {
        self.name = name
        self.barcode = barcode
    }
    
    init(name:String, barcode: String, location: String) {
        self.name = name
        self.barcode = barcode
        self.location = location
    }
    
    init(name:String, barcode: String, location: String, owner: String) {
        self.name = name
        self.barcode = barcode
        self.location = location
        self.owner = owner
    }
}