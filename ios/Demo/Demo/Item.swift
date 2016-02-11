//
//  Item.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation


class Item {
    var barcode: String
    var location: String
    var owner: User?
    
    init(barcode: String) {
        self.barcode = barcode
        self.location = "Virginia Tech"
//        self.owner = nil
    }
}