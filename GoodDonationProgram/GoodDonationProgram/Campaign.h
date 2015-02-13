//
//  Campaign.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

@interface Campaign : PFObject<PFSubclassing>

@property (nonatomic) BOOL submitted;
@property (nonatomic) BOOL approved;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * goal;
@property (nonatomic, retain) NSData * image;

+ (NSString *)parseClassName;

@end
