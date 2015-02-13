//
//  BNOrganizationViewController.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import "Organization.h"
#import "OrganizationType.h"
#import "Donation.h"

@interface BNOrganizationViewController : UIViewController

@property (nonatomic, strong) Organization     *organization;
@property (nonatomic, strong) OrganizationType *category;

- (void)loadOrganizationForDonation:(Donation *)donation;

@end
