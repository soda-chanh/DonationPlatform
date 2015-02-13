//
//  Type.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface OrganizationType : PFObject<PFSubclassing>

@property (nonatomic, retain) NSNumber * organizationTypeId;
@property (nonatomic, retain) NSString * organizationTypeName;
@property (nonatomic, retain) NSString * imageName;

+ (NSString *)parseClassName;

@end
