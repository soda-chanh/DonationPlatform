//
//  Campaign.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "Campaign.h"
#import <Parse/PFObject+Subclass.h>

@implementation Campaign

@dynamic submitted;
@dynamic approved;
@dynamic startDate;
@dynamic endDate;
@dynamic title;
@dynamic descriptionText;
@dynamic goal;
@dynamic image;

+ (NSString *)parseClassName {
    return @"Campaign";
}

@end
