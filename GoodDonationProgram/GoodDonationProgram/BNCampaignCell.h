//
//  BNCampaignCell.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import <UIKit/UIKit.h>
#import "Campaign.h"

@interface BNCampaignCell : UITableViewCell

- (void)configureForCampaign:(Campaign *)campaign;

@end
