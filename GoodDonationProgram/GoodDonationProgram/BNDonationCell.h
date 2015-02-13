//
//  BNDonationCell.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/11/13.
//
//

#import <UIKit/UIKit.h>
#import "Donation.h"

@interface BNDonationCell : UITableViewCell

- (void)configureForDonation:(Donation *)donation;

@end
