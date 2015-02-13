//
//  Organization.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Organization : PFObject<PFSubclassing>

@property (nonatomic, retain) NSNumber * organizationId;
@property (nonatomic, retain) NSString * organizationName;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSNumber * organizationType;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) PFFile   * image;
@property (nonatomic, strong) UIImage  * loadedImage;
@property (nonatomic, strong) UIImage  * thumbnail;

+ (NSString *)parseClassName;
- (void)loadImageWithCompletion:(void (^)(UIImage *image, NSError *error))completion;
- (BOOL)isFavorite;

@end