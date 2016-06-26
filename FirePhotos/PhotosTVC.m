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
//    Photo *testPhoto = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2F7C85382F-63D8-4A31-911F-061443EDC8EE.jpg?alt=media&token=c317532c-51e7-45d6-9482-f0604d00b124" andTimestamp:@"06/23/16"];
//    Photo *testPhoto2 = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2F7C9E2E72-31DC-4516-A033-93D5320F7024.jpg?alt=media&token=3843ac0f-e416-4c49-846d-8969c0fff9c7" andTimestamp:@"06/23/16"];
//        Photo *testPhoto3 = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2F1867F449-8176-4704-A39B-31627DB4C4FE.jpg?alt=media&token=9198a4a3-58e3-4acc-bd91-c857cc544f1e" andTimestamp:@"06/23/16"];
//        Photo *testPhoto4 = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2F3C4FC4D5-6502-4DE4-AB42-D41711BCD9F0.jpg?alt=media&token=061d2c08-63de-4a66-858e-19912da8dc4d" andTimestamp:@"06/23/16"];
//        Photo *testPhoto5 = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2FBFDF256F-41F6-4346-B50F-8F6F7D411927.jpg?alt=media&token=310de5c6-2270-40a2-8961-04c6897105e1" andTimestamp:@"06/23/16"];
    
    [self queryPhotosFromFirebase];
    _photoArray = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)queryPhotosFromFirebase {
    NSLog(@"Hello 1");
    FIRDatabaseReference *firebaseDatabaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *photosRef = [firebaseDatabaseRef.ref child:@"photos"];
    NSLog(@"Hello 2");

    [photosRef observeEventType: FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSLog(@"Hello 3");

        _photo = [[Photo alloc]initPhotoWithDownloadURL:snapshot.value[@"downloadURL"] andTimestamp:snapshot.value[@"timestamp"]];
        NSLog(@"Hello 4");

        [_photoArray addObject:_photo];
        NSLog(@"Hello 5");

        [self.tableView reloadData];
        
        NSLog(@"Hello 6");

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
