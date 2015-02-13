//
//  Donation.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Donation : PFObject<PFSubclassing>

@property (nonatomic, retain) NSNumber * donationId;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) PFRelation * organization;
@property (nonatomic, retain) PFRelation * user;
@property (nonatomic, retain) PFRelation * card;
@property (nonatomic, retain) NSNumber * longitutde;
@property (nonatomic, retain) NSNumber * latitude;

+ (NSString *)parseClassName;

@end
