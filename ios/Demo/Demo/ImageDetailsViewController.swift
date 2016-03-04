//
//  ImageDetailsViewController.swift
//  Demo
//
//  Created by Ning Li on 3/3/16.
//  Copyright © 2016 ningli. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    var image: UIImage?
    var notes: String?
    var uploadingDate: NSDate?

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var dateLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = self.image
        self.notesTextView.text = self.notes
        let timeStr = String(self.uploadingDate!)
        self.dateLabelView.text = timeStr.substringToIndex(timeStr.endIndex.advancedBy(-6))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
