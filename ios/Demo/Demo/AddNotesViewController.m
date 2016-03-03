//
//  AddNotesViewController.m
//  Demo
//
//  Created by Ning Li on 3/2/16.
//  Copyright © 2016 ningli. All rights reserved.
//

#import "AddNotesViewController.h"

@interface AddNotesViewController ()

@end

@implementation AddNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)uploadingImage:(id)sender {
     // get the Image ready for uploading
    NSData *data = UIImageJPEGRepresentation(self.image, 1.0f);
    // Or you can get the image url from AssetsLibrary
    //    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // Indicator
    UIAlertController *loadingAlert = [UIAlertController
                                       alertControllerWithTitle:@"Uploading"
                                       message:@"\n\n\n"
                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [loadingAlert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [loadingAlert addAction:cancel];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = loadingAlert.view.bounds;
    indicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    indicator.color = [UIColor blackColor];
    [loadingAlert.view addSubview:indicator];
    [indicator startAnimating];
    
     // Upload the chosen image to Azure
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
             NSLog(@"Container created or exists");
             // Create a local blob object
             NSString *uuid = [[NSUUID UUID] UUIDString];
             AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:uuid];
             
             // Upload blob to Storage
             [blockBlob uploadFromData:data completionHandler:^(NSError *uerror) {
                 if (uerror){
                     NSLog(@"Error in creating blob.");
                 } else {
                     // Alert box that indicates the success
                     NSLog(@"Complete!");
                     UIAlertController *alertController = [UIAlertController
                                                           alertControllerWithTitle:@"Congratulations!"
                                                           message:@"Image uploaded successfully"
                                                           preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* ok = [UIAlertAction
                                          actionWithTitle:@"OK"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                              [self performSegueWithIdentifier:@"FinishUploading" sender:nil];
                                          }];
                     [alertController addAction:ok];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [loadingAlert dismissViewControllerAnimated:YES completion:nil];
                         [self presentViewController:alertController animated:YES completion:nil];
                     });
                 }
             }];
         }
     }];
     
     [self presentViewController:loadingAlert animated:YES completion:nil];
}
@end
