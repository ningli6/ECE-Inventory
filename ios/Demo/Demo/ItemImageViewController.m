//
//  ItemImageViewController.m
//  Demo
//
//  Created by Ning Li on 2/25/16.
//  Copyright © 2016 ningli. All rights reserved.
//

#import "ItemImageViewController.h"

@interface ItemImageViewController ()

@end

@implementation ItemImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // display the image in the UIImageVIew
    self.itemImage.image = self.image; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateImageFromCamera:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)updateImageFromGallery:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)deleteImage:(id)sender {
    
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // display the image in the UIImageVIew
    self.itemImage.image = image;

    // get the Image ready for uploading
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    // Or you can get the image url from AssetsLibrary
    //    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    /* Upload the chosen image to Azure */
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=eceinventory;AccountKey=rzuspKSY65DcSH6EzOFMJrL6067TXKUP7+3iGX+eCNMlDkUJgngPe2irrrMGMZli7RaIlGFVdWmB9GsqYv9kbQ=="];
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object. A container name must be all lowercase.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:self.barcode];
    
    [blobContainer createContainerIfNotExistsWithAccessType:AZSContainerPublicAccessTypeContainer requestOptions:nil operationContext:nil completionHandler:^(NSError *error, BOOL exists)
     {
         if (error){
             NSLog(@"Error in creating container.");
         }
         else{
             // Create a local blob object
             AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:@"image"];
             
             // Upload blob to Storage
             [blockBlob uploadFromData:data completionHandler:^(NSError *error) {
                 if (error){
                     NSLog(@"Error in creating blob.");
                 } else {
                     // Alert box that indicates the success
                     NSLog(@"Complete!");
//                     UIAlertController *alertController = [UIAlertController
//                                                           alertControllerWithTitle:@"Congratulation!"
//                                                           message:@"Image uploaded successfully"
//                                                           preferredStyle:UIAlertControllerStyleAlert];
//                     
//                     UIAlertAction* ok = [UIAlertAction
//                                          actionWithTitle:@"OK"
//                                          style:UIAlertActionStyleDefault
//                                          handler:^(UIAlertAction * action)
//                                          {
//                                              //Do some thing here
//                                              [alertController dismissViewControllerAnimated:YES completion:nil];
//                                              
//                                          }];
//                     [alertController addAction:ok];
//                     
//                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }];
         }
     }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
