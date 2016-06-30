//
//  SelectedImageViewController.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SelectedImageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SelectedImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForSelectedImage;

@end

@implementation SelectedImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", _selectedImage.downloadURL);
    [_imageViewForSelectedImage setImageWithURL:[NSURL URLWithString:_selectedImage.downloadURL] placeholderImage:nil];
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

@end
