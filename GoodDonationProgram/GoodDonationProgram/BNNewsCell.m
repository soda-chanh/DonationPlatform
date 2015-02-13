//
//  BNNewsCell.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "BNNewsCell.h"

@interface BNNewsCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionTextLabel;

@end

@implementation BNNewsCell

- (void)configureForNews:(News *)news
{
    self.dateLabel.text = [self formatDate:news.date];
    self.titleLabel.text = news.title;
    self.descriptionTextLabel.text = news.descriptionText;
    CGRect newFrame = self.descriptionTextLabel.frame;
    newFrame.size.height = [self heightForNews:news];
    self.descriptionTextLabel.frame = newFrame;
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
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
    return (kDefaultDescriptionY + newHeight);
}
@end
