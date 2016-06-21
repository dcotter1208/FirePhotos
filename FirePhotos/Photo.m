//
//  Photo.m
//  FirePhotos
//
//  Created by DetroitLabs on 6/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initPhotoWithDownloadURL:(NSString *)downloadURL andTimestamp:(NSString *)timestamp {
    self = [super init];
    if (self) {
        _downloadURL = downloadURL;
        _timestamp = timestamp;
    }
    return self;
}

@end
