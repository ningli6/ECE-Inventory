//
//  Shared.swift
//  Demo
//
//  Created by Weijia on 3/14/17.
//  Copyright © 2017 ningli. All rights reserved.
//

final class Shared {
    static let shared = Shared() //lazy init, and it only runs once
    
    var user: User?
    var base_url: String = "https://vteceinventory.azurewebsites.net"//"http://192.168.1.10:2703" //"http://191.237.44.32/VTECEInventory"
    
}
