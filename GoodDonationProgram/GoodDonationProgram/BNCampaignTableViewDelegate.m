//
//  BNCampaignTableViewDelegate.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "BNCampaignTableViewDelegate.h"
#import "Campaign.h"
#import "BNCampaignCell.h"


#define kDefaultDescriptionSize CGSizeMake(10, 40)
#define kDefaultDescriptionY 25
#define kDefaultGoalSize CGSizeMake(10, 40)
#define kDefaultGoalY 25

@interface BNCampaignTableViewDelegate()

@end

@implementation BNCampaignTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Campaign *campaign = [self.campaigns objectAtIndex:indexPath.row];
    CGFloat height = [self heightforCampaign:campaign] + kDefaultDescriptionY + 40;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.campaigns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Campaign *campaign = [self.campaigns objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"BNCampaignCell";
    BNCampaignCell *cell = (BNCampaignCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureForCampaign:campaign];
    
    return cell;
}



- (CGFloat)heightforCampaign:(Campaign *)campaign
{
    UIFont *font = [UIFont fontWithName:@"BryantPro-Medium" size:14.];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:campaign.descriptionText attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:kDefaultDescriptionSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat newHeight = ceilf(rect.size.height);
    return (kDefaultDescriptionY + newHeight + 40);
}
@end
