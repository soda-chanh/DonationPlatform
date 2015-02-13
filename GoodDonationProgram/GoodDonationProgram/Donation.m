//
//  Donation.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import "Donation.h"
#import <Parse/PFObject+Subclass.h>


@implementation Donation

@dynamic donationId;
@dynamic amount;
@dynamic date;
@dynamic organization;
@dynamic user;
@dynamic longitutde;
@dynamic latitude;
@dynamic card;

+ (NSString *)parseClassName {
    return @"Donation";
}


//- (void)setOrganization:(PFRelation *)organization
//{
//     = organization;
//}
//
//- (PFRelation *)organization {
//    
//    if(_likes== nil) {
//        organization = [self relationforKey:@"organization"];
//    }
//    return _likes;
//}

@end
