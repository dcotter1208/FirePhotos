//
//  EntryVC.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/24/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "EntryVC.h"
#import "Photo.h"
@import MobileCoreServices;

@import Firebase;
@import FirebaseStorage;
@import FirebaseDatabase;

@interface EntryVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePicker;
//FIRStorageReference represents a reference to a Google Cloud Storage object.
@property (strong, nonatomic) FIRStorageReference *firebaseStorageRef;
//An instance of FIRStorage will initialize with the default FIRApp
@property (strong, nonatomic) FIRStorage *firebaseStorage;

@end

@implementation EntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self firebaseSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Camera Methods

-(void)presentCamera {
    _imagePicker = [[UIImagePickerController alloc] init];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
//    _imagePicker.mediaTypes = mediaTypes;
    [self presentViewController:_imagePicker animated:true completion:nil];
}

- (IBAction)cameraButtonPressed:(id)sender {
    [self presentCamera];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1);
    UIImage *image = [UIImage imageWithData:imageData];
    NSData *resizedImgData =  UIImageJPEGRepresentation([self reduceImageSize:image], .50);
    [self uploadPhotoToFirebase:resizedImgData];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(UIImage *)reduceImageSize:(UIImage *)image {
//    NSLog(@"ORIGINAL IMAGE: width-%f, height-%f", image.size.width, image.size.height);
    CGSize newSize = CGSizeMake(image.size.width/6, image.size.height/6);
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    NSLog(@"SMALL IMAGE: width-%f, height-%f", smallImage.size.width, smallImage.size.height);
    return smallImage;
}

#pragma mark Firebase Methods

-(void)firebaseSetUp {
    _firebaseStorage = [FIRStorage storage];
    _firebaseStorageRef = [_firebaseStorage referenceForURL:@"gs://firephotos-40912.appspot.com"];
}

-(void)uploadPhotoToFirebase:(NSData *)imageData {
    
    //Create a uniqueID for the image and add it to the end of the images reference.
    NSString *uniqueID = [[NSUUID UUID]UUIDString];
    NSString *newImageReference = [NSString stringWithFormat:@"images/%@.jpg", uniqueID];
    //imagesRef creates a reference for the images folder and then adds a child to that folder, which will be every time a photo is taken.
    FIRStorageReference *imagesRef = [_firebaseStorageRef child:newImageReference];
    //This uploads the photo's NSData onto Firebase Storage.
    FIRStorageUploadTask *uploadTask = [imagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.description);
        } else {
            Photo *photo = [[Photo alloc]initPhotoWithDownloadURL:[NSString stringWithFormat:@"%@", metadata.downloadURL] andTimestamp:[self createFormattedTimeStamp]];
            [self savePhotoObjectToFirebaseDatabase:photo];
        }
    }];
    [uploadTask resume];
}

-(void)savePhotoObjectToFirebaseDatabase:(Photo *)photo {
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *photosRef = [firebaseRef child:@"photos"].childByAutoId;
    NSDictionary *photoDict = @{@"downloadURL": photo.downloadURL, @"timestamp": photo.timestamp};
    
    [photosRef setValue:photoDict];
}

#pragma mark Timestamp and Date Formatter Methods
-(NSString *)createFormattedTimeStamp {
    NSDate *timestamp = [NSDate date];
    NSString *stringTimestamp = [self formatDate:timestamp];
    return stringTimestamp;
}


-(NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss a"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}


@end
