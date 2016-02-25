//
//  ItemImageViewController.h
//  Demo
//
//  Created by Ning Li on 2/25/16.
//  Copyright © 2016 ningli. All rights reserved.
//

#import <UIKit/UIKit.h>
// Include the following import statement to use blob APIs.
#import <Azure Storage Client Library/Azure_Storage_Client_Library.h>

@interface ItemImageViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property NSString* barcode;
@property UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

- (IBAction)updateImageFromCamera:(id)sender;

- (IBAction)updateImageFromGallery:(id)sender;

- (IBAction)deleteImage:(id)sender;

@end
