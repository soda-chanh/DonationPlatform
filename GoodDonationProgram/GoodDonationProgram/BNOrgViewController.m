//
//  BNOrgViewController.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import "BNOrgViewController.h"
#import <Parse/Parse.h>
#import "Organization.h"
#import "BNOrganizationCell.h"

@interface BNOrgViewController ()

@property (nonatomic, strong) NSArray *organizations;

@end

@implementation BNOrgViewController

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
    
    self.navigationController.navigationBarHidden = NO;
    
    // Load organization list
    PFQuery *query = [PFQuery queryWithClassName:kOrganization];
//    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            self.organizations = objects;
            [self.tableView reloadData];
//            [self createOrganizationList:objects];
            NSLog(@"Successfully retrieved %lu organizations.", (unsigned long)objects.count);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)createOrganizationList:(NSArray *)organizations
{
    for (int i=0; i<organizations.count; i++)
    {
        Organization *org = [organizations objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(10, 40+(i*110), 320-20, 100);
        UILabel  *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 15)];
        nameLabel.text = [org valueForKey:@"organizationName"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [button addSubview:nameLabel];
        
        UILabel  *blurbLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280, 80)];

        blurbLabel.font = [UIFont systemFontOfSize:12];
        blurbLabel.lineBreakMode = NSLineBreakByWordWrapping;
        blurbLabel.textAlignment = NSTextAlignmentLeft;
        blurbLabel.numberOfLines = 0;
//        [blurbLabel sizeToFit];
        blurbLabel.backgroundColor = [UIColor clearColor];
        [button addSubview:blurbLabel];
        
        NSLog(@"name = %@", nameLabel.text);
        NSLog(@"descr = %@", blurbLabel.text);

        [self.view addSubview:button];
    }

}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.organizations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"OrganizationCell";
    
    Organization *org = [_organizations objectAtIndex:indexPath.row];
    
    BNOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.nameLabel.text = [org valueForKey:@"organizationName"];
    
    return cell;
}


@end
