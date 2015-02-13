//
//  BNProfileViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import "BNProfileViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "Donation.h"
#import "BNOrganizationViewController.h"
#import "BNDonationCell.h"
#import <Parse/Parse.h>

@interface BNProfileViewController ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *donations;

@end

@implementation BNProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PFUser currentUser] saveInBackground];
    [self setupNavigationButtons];
    [self loadDonations];
}


- (void)loadDonations
{
    PFRelation *relation = [[PFUser currentUser] relationforKey:@"donations"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *donations, NSError *error) {
        _donations = donations;
        NSNumber *sum;
        for (Donation *donation in _donations)
        {
            sum = [NSNumber numberWithInteger:(sum.intValue + donation.amount.intValue)];
        }
        self.totalLabel.text = [NSString stringWithFormat:@"$%@", sum];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)emailReceipt:(id)sender
{
    
}

- (IBAction)logout:(id)sender
{
    [PFUser logOut];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Successfully logged out." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _donations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNDonationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNDonationCell" forIndexPath:indexPath];
    [cell configureForDonation:[_donations objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Donation *donation = [_donations objectAtIndex:indexPath.row];
    BNOrganizationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNOrganizationViewController"];
    [vc loadOrganizationForDonation:donation];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
