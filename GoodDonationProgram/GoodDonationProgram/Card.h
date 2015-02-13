//
//  Card.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/11/13.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Card : PFObject<PFSubclassing>

@property (nonatomic, retain) NSString * addressCountry;
@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * addressState;
@property (nonatomic, retain) NSString * addressZip;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * cvcCheck;
@property (nonatomic, retain) NSNumber * expiryMonth;
@property (nonatomic, retain) NSNumber * expiryYear;
@property (nonatomic, retain) NSString * lastFourDigits;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * securityCode;
@property (nonatomic, retain) NSString * type;

+ (NSString *)parseClassName;

@end
