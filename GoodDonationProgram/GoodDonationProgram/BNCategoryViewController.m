//
//  BNCategoryViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import "BNCategoryViewController.h"
#import "BNOrganizationCell.h"
#import "Organization.h"
#import <Parse/Parse.h>
#import "BNOrganizationViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "BNPageViewController.h"
#import "News.h"
#import "Campaign.h"

@interface BNCategoryViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSArray            *organizations;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation BNCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.backgroundColor = [UIColor clearColor];
    _imageView.image = [UIImage imageNamed:_category.imageName];
    [self setupNavigationButtons];
    [self loadOrganizations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadOrganizations
{
    PFQuery *query = [PFQuery queryWithClassName:kOrganization];
    [query whereKey:kOrganizationTypeId equalTo:_category.organizationTypeId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            _organizations = objects;
            [self.tableView reloadData];
            NSLog(@"Successfully retrieved %lu organizations.", (unsigned long)objects.count);
            
            // Add Test Data
//            [self addNewsData];
//            [self addCampaignData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)addNewsData
{
    for (Organization *org in _organizations)
    {
        News *news = [News object];
        [news saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PFRelation *relation = [news relationforKey:@"organization"];
            [relation addObject:org];
            [news saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Saved news.");
            }];
        }];
    }
}

- (void)addCampaignData
{
    for (Organization *org in _organizations)
    {
        Campaign *campaign = [Campaign object];
        [campaign saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PFRelation *relation = [campaign relationforKey:@"organization"];
            [relation addObject:org];
            [campaign saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Saved campaign.");
            }];
        }];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.organizations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Organization *org = [self.organizations objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"BNOrganizationCell";
    BNOrganizationCell *cell = (BNOrganizationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureWithOrganization:org];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNOrganizationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNOrganizationViewController"];
    vc.organization = [self.organizations objectAtIndex:indexPath.row];
    vc.category     = self.category;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
