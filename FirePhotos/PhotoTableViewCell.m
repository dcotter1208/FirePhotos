//
//  PhotoTableViewCell.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/24/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cellImageView.layer.borderWidth = 4.0;
    _cellImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _cellImageView.layer.cornerRadius = 111.50;
    _cellImageView.layer.masksToBounds = TRUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
