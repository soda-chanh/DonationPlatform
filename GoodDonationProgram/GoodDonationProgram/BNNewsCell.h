//
//  BNNewsCell.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface BNNewsCell : UITableViewCell

- (void)configureForNews:(News *)news;

@end
