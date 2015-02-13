//
//  UIAlertView+Blocks.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 10/13/13.
//
//

#import <UIKit/UIKit.h>

//define this handler outside the declaration as in category we cannot add instance variables, in .m file we will associate this with self
typedef void(^UIActionAlertViewCallBackHandler)(UIAlertView *alertView, NSInteger buttonIndex);


@interface UIAlertView (Blocks) <UIAlertViewDelegate>

- (void)showAlerViewFromButtonAction:(UIButton *)clickedButton animated:(BOOL)animated handler:(UIActionAlertViewCallBackHandler)handler;

@end
