//
//  BNCategoryViewController.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import "OrganizationType.h"

@interface BNCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) OrganizationType *category;

@end
