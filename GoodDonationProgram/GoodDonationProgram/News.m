//
//  News.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "News.h"
#import <Parse/PFObject+Subclass.h>

@implementation News

@dynamic image;
@dynamic title;
@dynamic descriptionText;
@dynamic organization;
@dynamic date;

+ (NSString *)parseClassName {
    return @"News";
}

@end
