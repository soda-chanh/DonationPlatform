//
//  Organization.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import "Organization.h"
#import <Parse/PFObject+Subclass.h>
#import "UIImage+Thumbnail.h"


@implementation Organization

@dynamic organizationId;
@dynamic organizationName;
@dynamic about;
@dynamic organizationType;
@dynamic latitude;
@dynamic longitude;
@dynamic imageId;
@dynamic image;

@synthesize loadedImage;
@synthesize thumbnail;

+ (NSString *)parseClassName {
    return @"Organization";
}

- (void)loadImageWithCompletion:(void (^)(UIImage *image, NSError *error))completion
{
    if (loadedImage) {
        completion(loadedImage, nil);
    }
    else {
        [self.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                loadedImage = [UIImage imageWithData:imageData];
                completion(loadedImage, error);
            }
        }];
    }
}

- (UIImage *)thumbnail
{
    if (thumbnail)
        return thumbnail;
    else {
        thumbnail = [loadedImage thumbnailOfSize:CGSizeMake(42, 46)];
        return thumbnail;
    }
}

- (BOOL)isFavorite
{
    NSArray *favorites = [[BNGlobalState sharedManager] userFavorites];
    for (Organization *organization in favorites) {
        if ([organization.objectId isEqualToString:self.objectId]) {
            return YES;
        }
    }
    return NO;
}

@end
