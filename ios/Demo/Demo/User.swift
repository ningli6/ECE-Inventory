//
//  User.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation


class User {
    // user name
    var name: String?
    // a list of item
    var items: [Item]?
    
    init() {
        self.items = []
    }
}