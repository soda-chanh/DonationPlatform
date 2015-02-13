//
//  BNBryantLabel.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/22/13.
//
//

#import "BNBryantMediumLabel.h"

@implementation BNBryantMediumLabel


- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"BryantPro-Medium" size:self.font.pointSize];
}


@end
