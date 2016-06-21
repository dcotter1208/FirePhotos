//
//  FirePhotoCVC.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "FirePhotoCVC.h"
#import "Photo.h"
@import Firebase;
@import FirebaseStorage;
@import FirebaseDatabase;

@interface FirePhotoCVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
//FIRStorageReference represents a reference to a Google Cloud Storage object.
@property (strong, nonatomic) FIRStorageReference *firebaseStorageRef;
//An instance of FIRStorage will initialize with the default FIRApp
@property (strong, nonatomic) FIRStorage *firebaseStorage;

@end

@implementation FirePhotoCVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [self firebaseSetUp];
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark Camera Methods

-(void)presentCamera {
    _imagePicker = [[UIImagePickerController alloc] init];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:_imagePicker animated:true completion:nil];
}

- (IBAction)cameraButtonPressed:(id)sender {
    [self presentCamera];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1);
    [self uploadPhotoToFirebase:imageData];
    [self dismissViewControllerAnimated:true completion:nil];
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
    NSLog(@"Photos Ref: %@", photosRef);
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

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
