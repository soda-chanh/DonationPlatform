//
//  BNIAPHelper.m
//  BegNoMore
//
//  Created by Stacey Dao on 1/17/13.
//
//

#import "BNIAPHelper.h"

@implementation BNIAPHelper

+ (BNIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static BNIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.GoodDonationProgram.GoodDonationProgram",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
