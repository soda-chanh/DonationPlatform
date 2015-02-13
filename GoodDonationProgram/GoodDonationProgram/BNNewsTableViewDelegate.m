//
//  BNNewsTableViewDelegate.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "BNNewsTableViewDelegate.h"
#import "BNNewsCell.h"

@implementation BNNewsTableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.news objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"BNNewsCell";
    BNNewsCell *cell = (BNNewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell configureForNews:news];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self heightForNews:[self.news objectAtIndex:indexPath.row]];
    CGSize size = CGSizeMake(300, height);
    return size.height;
}

#define kDefaultDescriptionSize CGSizeMake(300, 600)
#define kDefaultDescriptionY 40

- (CGFloat)heightForNews:(News *)news
{
    UIFont *font = [UIFont fontWithName:@"BryantPro-Medium" size:14.];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:news.descriptionText attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:kDefaultDescriptionSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat newHeight = ceilf(rect.size.height);
    return (kDefaultDescriptionY + newHeight + 40);
}

@end
