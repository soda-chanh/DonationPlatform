//
//  User.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFUser

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
//@property (nonatomic, retain) NSString * email;
//@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) PFRelation *favoriteOrganizations;
@property (nonatomic, retain) NSDate   * birthday;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * pin;

@end
