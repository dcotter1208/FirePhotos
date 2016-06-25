//
//  PhotosTVC.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/24/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "PhotosTVC.h"
#import "Photo.h"

@interface PhotosTVC ()

@property(nonatomic, strong) NSMutableArray *photoArray;

@end

@implementation PhotosTVC

- (void)viewDidLoad {
    Photo *testPhoto = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2F7C85382F-63D8-4A31-911F-061443EDC8EE.jpg?alt=media&token=c317532c-51e7-45d6-9482-f0604d00b124" andTimestamp:@"06/23/16"];
    Photo *testPhoto2 = [[Photo alloc]initPhotoWithDownloadURL:@"https://firebasestorage.googleapis.com/v0/b/firephotos-40912.appspot.com/o/images%2F7C9E2E72-31DC-4516-A033-93D5320F7024.jpg?alt=media&token=3843ac0f-e416-4c49-846d-8969c0fff9c7" andTimestamp:@"06/23/16"];
    _photoArray = [[NSMutableArray alloc]initWithObjects:testPhoto, testPhoto2, nil];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_photoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Photo *photo = [_photoArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.downloadURL]]];
    
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
