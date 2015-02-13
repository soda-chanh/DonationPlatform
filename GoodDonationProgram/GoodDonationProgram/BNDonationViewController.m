//
//  BNDonationViewController.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import "BNDonationViewController.h"
#import "BNCreateAccountViewController.h"
#import "BNGlobalState.h"

@interface BNDonationViewController ()

@property (nonatomic, strong) IBOutlet UITextField *amountTextField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation BNDonationViewController

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
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedOneDollarButton:(id)sender
{
    NSDecimalNumber *amount = [[NSDecimalNumber alloc] initWithInt:1];
    [[BNGlobalState sharedManager] setPendingAmount:amount];
}

- (IBAction)selectedFiveDollarButton:(id)sender
{
    NSDecimalNumber *amount = [[NSDecimalNumber alloc] initWithInt:5];
    [[BNGlobalState sharedManager] setPendingAmount:amount];
}

- (IBAction)selectedTenDollarButton:(id)sender
{
    NSDecimalNumber *amount = [[NSDecimalNumber alloc] initWithInt:10];
    [[BNGlobalState sharedManager] setPendingAmount:amount];
}

- (IBAction)selectedContinueButton:(id)sender
{
    NSDecimalNumber *pendingAmount = [[BNGlobalState sharedManager] pendingAmount];
    if (_amountTextField.text == nil || [_amountTextField.text isEqualToString:@""] || !pendingAmount || pendingAmount == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"You must enter or select an amount to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else
    {
        [self performSegueWithIdentifier:@"Continue" sender:self];
    }
}


#pragma mark - Keyboard

CGPoint originalScrollOffset;
CGSize originalContentSize;
- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // get the keyboard height
    double keyboardHeight = kbSize.height;
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // The calculations are little different for landscape mode.
    if (UIInterfaceOrientationLandscapeLeft == currentOrientation ||UIInterfaceOrientationLandscapeRight == currentOrientation ) {
        keyboardHeight = kbSize.width;
    }
    
    originalContentSize = _scrollView.contentSize;
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + keyboardHeight);
    
    // save the position of the scroll view, so that we can scroll it to its original position when keyboard disappears.
    originalScrollOffset = _scrollView.contentOffset;
    
    CGPoint cp = [_currentTextField convertPoint:_currentTextField.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    cp.y += _currentTextField.frame.size.height;
    
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    double sh = bounds.size.height; // assumes portrait
    
    // scroll if the keyboard is hiding the text view
    if(cp.y > sh - keyboardHeight){
        double sofset = cp.y - (sh - keyboardHeight);
        CGPoint offset = _scrollView.contentOffset;
        offset.y += sofset;
        _scrollView.contentOffset = offset;
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    // restore the scroll position
    self.scrollView.contentSize = originalContentSize;
    _scrollView.contentOffset = originalScrollOffset;
}

- (void)dismissKeyboard:(id)sender
{
    [_currentTextField resignFirstResponder];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:textField.text];
    [[BNGlobalState sharedManager] setPendingAmount:amount];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
