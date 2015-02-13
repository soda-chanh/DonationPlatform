//
//  BNFavoritesViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import "BNFavoritesViewController.h"
#import <Parse/Parse.h>
#import "Organization.h"
#import "BNOrganizationCell.h"
#import "BNOrganizationViewController.h"

@interface BNFavoritesViewController ()

@property (nonatomic, strong) NSArray *organizations;

@end

@implementation BNFavoritesViewController


- (id)initWithStoryboard:(UIStoryboard *)storyboard
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadFavorites];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)loadFavorites
{
    _organizations = [[BNGlobalState sharedManager] userFavorites];
    [self.tableView reloadData];
//    PFRelation *relation = [[PFUser currentUser] relationforKey:@"favoriteOrganizations"];
//    PFQuery *query = [relation query];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *organizations, NSError *error) {
//        _organizations = organizations;
//        [self.tableView reloadData];
//    }];
}


- (IBAction)signUpWithFacebook:(id)sender
{
    NSArray *permissionsArray = @[@"email", @"user_birthday"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self createUser];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self loginSuccessful];
        }
    }];
}

- (void)loginSuccessful
{
    [self loadFavorites];
}

- (void)createUser
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // Store the current user's Facebook ID on the user
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"id"]]
                                     forKey:@"fbId"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"birthday"]]
                                     forKey:@"birthday"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"first_name"]]
                                     forKey:@"first_name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"last_name"]]
                                     forKey:@"last_name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"location"]]                                     forKey:@"location"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"middle_name"]]
                                     forKey:@"middle_name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"name"]]
                                     forKey:@"name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"username"]]
                                     forKey:@"username"];
            [[PFUser currentUser] saveInBackground];
            
            //            [self requestUserInfo];
        }
    }];
}

- (void)requestUserInfo
{
    // Issue a Facebook Graph API request to get your user's friend list
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            //            NSArray *friendUsers = [friendQuery findObjects];
        }
    }];
}



#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _organizations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Organization *organization = [_organizations objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"BNOrganizationCell";
    BNOrganizationCell *cell = (BNOrganizationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureWithOrganization:organization];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNOrganizationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNOrganizationViewController"];
    vc.organization = [self.organizations objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper Functions

- (id)objectValueIgnoringNSNULL:(id)objectValue
{
    return (objectValue ? objectValue : [[NSNull alloc] init]);
}

@end