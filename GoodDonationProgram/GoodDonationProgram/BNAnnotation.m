//
//  BNAnnotation.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 4/14/14.
//
//

#import "BNAnnotation.h"

@interface BNAnnotation()

@property (nonatomic, strong) Organization *organization;

@end

@implementation BNAnnotation

- (id)initWithOrganization:(Organization*)organization
{
    if (self = [super init]) {
        _organization = organization;
    }
    return self;
}

@end
