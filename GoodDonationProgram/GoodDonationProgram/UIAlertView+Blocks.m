//
//  UIAlertView+Blocks.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 10/13/13.
//
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>


@implementation UIAlertView (Blocks)

//Runtime association key.
static NSString *handlerRunTimeAccosiationKey = @"alertViewBlocksDelegate";

- (void)showAlerViewFromButtonAction:(UIButton *)clickedButton animated:(BOOL)animated handler:(UIActionAlertViewCallBackHandler)handler {
    
    //set runtime accosiation of object
    //param -  sourse object for association, association key, association value, policy of association
    objc_setAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setDelegate:self];
    [self show];  //call UIAlertView show method
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIActionAlertViewCallBackHandler completionHandler = objc_getAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey));
    
    if (completionHandler != nil) {
        
        completionHandler(alertView, buttonIndex);
    }
}

@end
