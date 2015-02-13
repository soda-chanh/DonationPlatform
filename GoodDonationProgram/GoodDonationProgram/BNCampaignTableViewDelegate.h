//
//  BNCampaignTableViewDelegate.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import <Foundation/Foundation.h>

@interface BNCampaignTableViewDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *campaigns;

@end
