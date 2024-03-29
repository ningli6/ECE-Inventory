//
//  ItemImageViewController.m
//  Demo
//
//  Created by Ning Li on 2/25/16.
//  Copyright © 2016 ningli. All rights reserved.
//

#import "AddImageViewController.h"
#import "AddNotesViewController.h"

@interface AddImageViewController ()

@end

@implementation AddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

// This method is called when an image has been chosen from the library or taken from the camera.
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.image = image;
    // display the image in the UIImageVIew
    self.itemImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)addNotes:(id)sender {
    if (self.image == nil) {
        // warning
        UIAlertController *alert = [UIAlertController
                                           alertControllerWithTitle:@"Choose an image first"
                                           message:@""
                                           preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"AddNotesSegue" sender:nil];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"AddNotesSegue"]) {
        AddNotesViewController* destView = [segue destinationViewController];
        destView.image = self.image;
        destView.barcode = self.barcode;
    }
}

@end
