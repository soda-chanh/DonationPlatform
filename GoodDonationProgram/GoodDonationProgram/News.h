//
//  News.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface News : PFObject<PFSubclassing>

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) PFRelation *organization;

+ (NSString *)parseClassName;

@end
