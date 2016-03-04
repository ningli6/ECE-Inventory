//
//  AddNotesViewController.h
//  Demo
//
//  Created by Ning Li on 3/2/16.
//  Copyright © 2016 ningli. All rights reserved.
//

#import <UIKit/UIKit.h>
// Include the following import statement to use blob APIs.
#import <Azure Storage Client Library/Azure_Storage_Client_Library.h>

@interface AddNotesViewController : UIViewController

@property UIImage * image;
@property NSString * barcode;
@property NSString * notes;

@property (weak, nonatomic) IBOutlet UITextView *notesForImage;

- (IBAction)uploadingImage:(id)sender;

@end
