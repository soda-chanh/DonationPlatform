//
//  BNDonateViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/25/13.
//
//

#import "BNDonateViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "BNLoginViewController.h"
#import "BNGlobalState.h"
#import "BNStripeViewController.h"

@interface BNDonateViewController ()

@property (nonatomic, strong) IBOutlet UITextField            *textField;

@end

@implementation BNDonateViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _textField.delegate = self;
    [self setupNavigationButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)keypad1Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"1"];
}

- (IBAction)keypad2Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"2"];
}

- (IBAction)keypad3Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"3"];
}

- (IBAction)keypad4Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"4"];
}

- (IBAction)keypad5Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"5"];
}

- (IBAction)keypad6Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"6"];
}

- (IBAction)keypad7Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"7"];
}

- (IBAction)keypad8Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"8"];
}

- (IBAction)keypad9Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"9"];
}

- (IBAction)keypad0Pressed:(id)sender
{
    _textField.text = [_textField.text stringByAppendingString:@"0"];
}

- (IBAction)amount5Pressed:(id)sender
{
    _textField.text = @"5";
}

- (IBAction)amount10Pressed:(id)sender
{
    _textField.text = @"10";
}

- (IBAction)amount20Pressed:(id)sender
{
    _textField.text = @"20";
}

- (IBAction)giveButtonPressed:(id)sender
{
    // TODO:
    // if not already logged in..
    
    NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:_textField.text];
    if (number > 0 && ![number isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        [self.textField resignFirstResponder];
        [[BNGlobalState sharedManager] setPendingAmount:number];
        BOOL isLoggedIn = [[BNGlobalState sharedManager] isLoggedIn];
        if (isLoggedIn)
        {
            BNStripeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNStripeViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [[BNGlobalState sharedManager] setPendingViewController:@"BNStripeViewController"];
            BNLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNLoginViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"You must enter or select an amount to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)delete:(id)sender
{
    if (_textField.text.length)
    {
        NSString *substring = [_textField.text substringToIndex:_textField.text.length-1];
        _textField.text = substring;
    }
}


@end
