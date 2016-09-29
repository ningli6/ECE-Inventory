//
//  ImageCollectionViewCell.swift
//  Demo
//
//  Created by Ning Li on 3/2/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // Notes Id (blob name)
    var notesId: String?
    // uploading date for that image and notes
    var uploadingDate: Date?
    
    @IBOutlet weak var imageView: UIImageView!

}
