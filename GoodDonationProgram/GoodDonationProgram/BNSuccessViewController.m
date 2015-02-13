//
//  BNSuccessViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/30/13.
//
//

#import "BNSuccessViewController.h"
#import "UIViewController+CustomNavigationItems.h"

@interface BNSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizationLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendReceiptButton;

@end

@implementation BNSuccessViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationButtonsWithBackButton:NO];
    self.navigationItem.hidesBackButton = YES;
    self.amountLabel.text = [NSString stringWithFormat:@"$%@",[[BNGlobalState sharedManager] pendingAmount]];
    self.organizationLabel.text = [NSString stringWithFormat:@"has been submitted to %@!", [[[BNGlobalState sharedManager] pendingOrganization] organizationName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendReceiptButtonTapped:(id)sender
{
    [PFCloud callFunctionInBackground:@"sendMail"
                       withParameters:@{@"text": @"Thank you for your donation to XYZ",
                                        @"subject": @"Thank you for your donation",
                                        @"fromEmail": @"gdp@gpd.omc",
                                        @"fromName": @"Good Donation Program",
                                        @"toEmail": self.emailTextField.text,
                                        @"toName": @"GDP Donator"}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your receipt has been emailed to you." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.emailTextField.hidden = YES;
    self.sendReceiptButton.hidden = YES;
}

@end
