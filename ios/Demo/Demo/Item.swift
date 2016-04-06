//
//  Item.swift
//  Demo
//
//  Created by Ning Li on 2/11/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import Foundation


class Item {
    
    var owner: String?
    var orgnCode: String?
    var orgnTitle: String?
    var room: String?
    var bldg: String?
    // location
    var sortRoom: String?
    // barcode
    var ptag: String?
    var manufacturer: String?
    var model: String?
    var sn: String?
    // full name
    var description: String?
    // current user
    var custodian: String?
    var po: String?
    var acqDate: String?
    var amt: String?
    var ownership: String?
    var schevYear: String?
    var tagType: String?
    var assetType: String?
    // brief name
    var atypTitle: String?
    var condition: String?
    var lastInvDate: String?
    var designation: String?
    
    init(owner: String, orgnCode: String, orgnTitle: String, room: String, bldg: String, sortRoom: String, ptag: String, manufacturer: String, model: String, sn: String, description: String, custodian: String, po: String, acqDate: String, amt: String, ownership: String, schevYear: String, tagType: String, assetType: String, atypTitle: String, condition: String, lastInvDate: String, designation: String) {
        self.owner = owner
        self.orgnCode = orgnCode
        self.orgnTitle = orgnTitle
        self.room = room
        self.bldg = bldg
        self.sortRoom = sortRoom
        self.ptag = ptag
        self.manufacturer = manufacturer
        self.model = model
        self.sn = sn
        self.description = description
        self.custodian = custodian
        self.po = po
        self.acqDate = acqDate
        self.amt = amt
        self.ownership = ownership
        self.schevYear = schevYear
        self.tagType = tagType
        self.assetType = assetType
        self.atypTitle = atypTitle
        self.condition = condition
        self.lastInvDate = lastInvDate
        self.designation = designation
    }

}