//
//  BNDonationCell.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/11/13.
//
//

#import "BNDonationCell.h"

@interface BNDonationCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

- (void)configureForDonation:(Donation *)donation;

@end

@implementation BNDonationCell


- (void)configureForDonation:(Donation *)donation
{
    self.dateLabel.text = [self formatDate:donation.date];
    self.amountLabel.text = [NSString stringWithFormat:@"%@", donation.amount];
}

- (NSString *)formatDate:(NSNumber *)dateNumber
{
    NSNumber *time = [NSNumber numberWithDouble:([dateNumber doubleValue] - 3600)];
    NSTimeInterval interval = [time doubleValue];
    NSDate *online = [NSDate date];
    online = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:online];
}

@end
