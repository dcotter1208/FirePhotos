//
//  Photo.h
//  FirePhotos
//
//  Created by DetroitLabs on 6/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString *downloadURL;
@property (nonatomic, strong) NSString *timestamp;

-(instancetype)initPhotoWithDownloadURL:(NSString *)downloadURL andTimestamp:(NSString *)timestamp;

@end
