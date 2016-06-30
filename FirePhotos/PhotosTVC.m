//
//  PhotosTVC.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/24/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "PhotosTVC.h"
#import "Photo.h"
#import "PhotoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SelectedImageViewController.h"
@import FirebaseDatabase;

@interface PhotosTVC ()

@property(nonatomic, strong) NSMutableArray *photoArray;
@property(nonatomic, strong) Photo *photo;
@property(nonatomic, strong) UIImage *selectedPhoto;
@end

@implementation PhotosTVC

- (void)viewDidLoad {
    [self queryPhotosFromFirebase];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)queryPhotosFromFirebase {
    _photoArray = [[NSMutableArray alloc]init];

    FIRDatabaseReference *firebaseDatabaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *photosRef = [firebaseDatabaseRef.ref child:@"photos"];

    [photosRef observeEventType: FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {

        _photo = [[Photo alloc]initPhotoWithDownloadURL:snapshot.value[@"downloadURL"] andTimestamp:snapshot.value[@"timestamp"]];

        [_photoArray addObject:_photo];
        [self.tableView reloadData];

    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_photoArray count];
}

- (PhotoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Photo *photo = [_photoArray objectAtIndex:indexPath.row];
    
    [cell.cellImageView setImageWithURL:[NSURL URLWithString:photo.downloadURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

#pragma mark - PrepareForSegue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SelectedImageViewController *destVC = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    Photo *selectedPhotoToPass = [_photoArray objectAtIndex:indexPath.row];
    destVC.selectedImage = selectedPhotoToPass;
        
}


@end
