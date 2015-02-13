//
//  BNBryantLightLabel.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 1/24/14.
//
//

#import "BNBryantLightLabel.h"

@implementation BNBryantLightLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"BryantPro-Light" size:self.font.pointSize];
}


@end
