//
//  UIViewController+CustomNavigationItems.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/1/13.
//
//

#import "UIViewController+CustomNavigationItems.h"
#import "BNProfileViewController.h"
#import "BNLoginViewController.h"
#import "BNRegistrationViewController.h"

@implementation UIViewController (CustomNavigationItems)

- (void)setupNavigationButtons
{
    [self setupNavigationButtonsWithBackButton:YES];
}

- (void)setupNavigationButtonsWithBackButton:(BOOL)showBackButton
{
    UIBarButtonItem *backItem;
    if (showBackButton) {
        UIImage *backImage = [UIImage imageNamed:@"backButton"];
        if (self.navigationController.viewControllers.count > 1)
        {
            UIImage *backImage = [UIImage imageNamed:@"backButton"];
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setImage:backImage forState:UIControlStateNormal];
            backButton.frame = CGRectMake(0.0, 0.0, backImage.size.width, backImage.size.height);
            [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        } else
        {
            backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            backItem.width = backImage.size.width;
        }
    }
    
    UIImage *homeImage = [UIImage imageNamed:@"homebutton"];
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setImage:homeImage forState:UIControlStateNormal];
    homeButton.frame = CGRectMake(0.0, 0.0, homeImage.size.width, homeImage.size.height);
    [homeButton addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc]initWithCustomView:homeButton];
    
    NSArray *items;
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace          target:nil action:nil];
    
    //    UIImage *profileImage = [UIImage imageNamed:@"profileButton"];
    //    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [profileButton setImage:profileImage forState:UIControlStateNormal];
    //    profileButton.frame = CGRectMake(0.0, 5.0, profileImage.size.width, profileImage.size.height);
    //    [profileButton addTarget:self action:@selector(profileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *profileItem = [[UIBarButtonItem alloc]initWithCustomView:profileButton];
    
    UIBarButtonItem *shorterWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    shorterWidth.width = 112;
    UIBarButtonItem *largerWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    largerWidth.width = 200;
    
    items = (backItem ? @[backItem, shorterWidth, homeItem, largerWidth] : @[flexItem, homeItem, flexItem]);//[NSArray arrayWithObjects: (backItem ? backItem, flexItem, homeItem : homeItem), /*flexItem, profileItem,*/ nil];
    
    self.navigationItem.leftBarButtonItems = items;
}


- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)homeButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)profileButtonPressed:(id)sender
{
    if ([[PFUser currentUser] isAuthenticated]) {
        if (![[self.navigationController.viewControllers lastObject] isKindOfClass:[BNProfileViewController class]]) {
            BNProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNProfileViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        if (![[self.navigationController.viewControllers lastObject] isKindOfClass:[BNLoginViewController class]] && ![[self.navigationController.viewControllers lastObject] isKindOfClass:[BNRegistrationViewController class]]) {
            [[BNGlobalState sharedManager] setPendingViewController:@"BNProfileViewController"];
            BNLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNLoginViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
