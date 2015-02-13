//
//  BNNewsTableViewDelegate.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface BNNewsTableViewDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *news;

@end
