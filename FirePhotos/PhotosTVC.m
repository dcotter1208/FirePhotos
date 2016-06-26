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
@import FirebaseDatabase;

@interface PhotosTVC ()

@property(nonatomic, strong) NSMutableArray *photoArray;
@property(nonatomic, strong) Photo *photo;
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
    
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.downloadURL]]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
