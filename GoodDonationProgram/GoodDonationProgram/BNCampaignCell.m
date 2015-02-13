//
//  BNCampaignCell.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "BNCampaignCell.h"

@interface BNCampaignCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *goalLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation BNCampaignCell


- (void)configureForCampaign:(Campaign *)campaign
{
    self.dateLabel.text = [self formatDate:campaign.startDate];
    self.titleLabel.text = campaign.title;
    self.descriptionTextLabel.text = campaign.descriptionText;
    self.goalLabel.text = campaign.goal;
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


#define kDefaultDescriptionSize CGSizeMake(10, 40)
#define kDefaultDescriptionY 25

- (CGFloat)heightForNews:(Campaign *)campaign
{
    UIFont *font = [UIFont fontWithName:@"BryantPro-Medium" size:14.];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:campaign.goal attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:kDefaultDescriptionSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGFloat newHeight = ceilf(rect.size.height);
    return (kDefaultDescriptionY + newHeight + 40);
}


@end
