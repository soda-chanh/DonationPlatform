//
//  Card.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/11/13.
//
//

#import "Card.h"
#import <Parse/PFObject+Subclass.h>


@implementation Card

@dynamic addressCountry;
@dynamic addressLine1;
@dynamic addressLine2;
@dynamic addressState;
@dynamic addressZip;
@dynamic country;
@dynamic cvcCheck;
@dynamic expiryMonth;
@dynamic expiryYear;
@dynamic lastFourDigits;
@dynamic name;
@dynamic number;
@dynamic securityCode;
@dynamic type;

+ (NSString *)parseClassName {
    return @"Card";
}

@end
