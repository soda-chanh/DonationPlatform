//
//  BNPageViewController.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/12/13.
//
//

#import <UIKit/UIKit.h>
#import "Organization.h"
#import "OrganizationType.h"

@interface BNPageViewController : UIViewController

@property (nonatomic, strong) Organization     *organization;
@property (nonatomic, strong) OrganizationType *category;

@end
