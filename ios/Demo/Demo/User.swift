//
//  User.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation


class User {
    var id: String
    var name: String
    var email: String
    var items: [Item]
    
    init() {
        self.id = "vt"
        self.name = "Virginia Tech"
        self.email = "email@vt.edu"
        self.items = [
            Item(name: "Mac air", barcode: "0123456789"),
            Item(name: "IMac", barcode: "0123456789"),
            Item(name: "HP Printer", barcode: "0123456789")
            ]
    }
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        self.items = []
    }
    
    init(id: String, name: String, email: String, items: [Item]) {
        self.id = id
        self.name = name
        self.email = email
        self.items = items
    }
}