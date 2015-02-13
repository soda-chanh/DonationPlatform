//
//  Type.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import "OrganizationType.h"
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@implementation OrganizationType

@dynamic organizationTypeId;
@dynamic organizationTypeName;
@dynamic imageName;

+ (NSString *)parseClassName {
    return @"OrganizationType";
}

@end
