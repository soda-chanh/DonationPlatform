//
//  BNStripeViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/30/13.
//
//

#import "BNStripeViewController.h"
#import "BNSuccessViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "Donation.h"
#import "Card.h"

#define kStripeTestCardNumber 4242424242424242

@interface BNStripeViewController ()

@end

@implementation BNStripeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationButtons];
    self.stripeConnection = [StripeConnection connectionWithPublishableKey:kStripePublishableKey];
    
    self.nameField.inputAccessoryView = self.keyboardToolbar;
    self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nameField.returnKeyType = UIReturnKeyNext;
    
    self.numberField.inputAccessoryView = self.keyboardToolbar;
    self.numberField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.expiryField.inputAccessoryView = self.keyboardToolbar;
    self.expiryField.inputView = self.pickerView;
    
    self.CVCField.inputAccessoryView = self.keyboardToolbar;
    self.CVCField.keyboardType = UIKeyboardTypeNumberPad;
    self.CVCField.returnKeyType = UIReturnKeyGo;
    
    self.fields = [NSArray arrayWithObjects:
                   self.nameField,
                   self.numberField,
                   self.expiryField,
                   self.CVCField,
                   nil];
}

- (void)cancel:(id)sender {
    //    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger i = [self.fields indexOfObject:textField];
    if (i < self.fields.count - 1) {
        [[self.fields objectAtIndex:i + 1] becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger i = [self.fields indexOfObject:textField];
    if (i == self.fields.count - 1) {
        [self.segmentedControl setEnabled:YES forSegmentAtIndex:0];
        [self.segmentedControl setEnabled:NO forSegmentAtIndex:1];
    } else if (i == 0) {
        [self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [self.segmentedControl setEnabled:YES forSegmentAtIndex:1];
    } else {
        [self.segmentedControl setEnabled:YES forSegmentAtIndex:0];
        [self.segmentedControl setEnabled:YES forSegmentAtIndex:1];
    }
    
    if (textField == self.expiryField && (!self.expiryField.text || self.expiryField.text.length == 0)) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
    
    return YES;
}

- (void)viewDidUnload {
    self.fields = nil;
    [super viewDidUnload];
}

- (IBAction)fieldSelected:(UISegmentedControl *)control {
    NSInteger idx = NSNotFound;
    NSInteger i = 0;
    for (UIResponder *r in self.fields) {
        if (r.isFirstResponder) {
            idx = i;
            break;
        }
        
        i++;
    }
    
    if (idx == NSNotFound) return;
    
    if (control.selectedSegmentIndex == 0) {
        if (idx > 0) {
            [[self.fields objectAtIndex:idx - 1] becomeFirstResponder];
        }
    } else {
        if (idx < self.fields.count - 1) {
            [[self.fields objectAtIndex:idx + 1] becomeFirstResponder];
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? 12 : 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
        return [NSString stringWithFormat:@"%02li", (long)row + 1];
    else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        return [[NSNumber numberWithInteger:[components year] + row] stringValue];
    }
}

- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *month = [self pickerView:aPickerView
                           titleForRow:[self.pickerView selectedRowInComponent:0]
                          forComponent:0];
    NSString *year = [self pickerView:aPickerView
                          titleForRow:[self.pickerView selectedRowInComponent:1]
                         forComponent:1];
    self.expiryField.text = [NSString stringWithFormat:@"%02ld/%@", (long)[month integerValue], year];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nameField becomeFirstResponder];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0)
        return 50.0f;
    else
        return 80.0f;
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    StripeCard *card      = [[StripeCard alloc] init];
    card.number           = self.numberField.text;
    
    NSArray *date = [self.expiryField.text componentsSeparatedByString:@"/"];
    if (date.count == 2) {
        card.expiryMonth      = [NSNumber numberWithInteger:[[date objectAtIndex:0] integerValue]];
        card.expiryYear       = [NSNumber numberWithInteger:[[date objectAtIndex:1] integerValue]];
    }
    
    card.name         = self.nameField.text;
    card.securityCode = self.CVCField.text;
    
    sender.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.stripeConnection performRequestWithCard:card
                                          success:^(StripeResponse *response)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [self createStripePayment:response];
         sender.enabled = YES;
     }
                                            error:^(NSError *error)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         sender.enabled = YES;
         [self showStripeError:error];
     }];
}

- (void)createStripePayment:(StripeResponse *)stripeResponse
{
    NSNumber *amountInCents = [NSNumber numberWithFloat:([[[BNGlobalState sharedManager] pendingAmount] floatValue] * 100.)];
    NSDictionary *params = @{@"amount" : amountInCents, @"card" : stripeResponse.token};
    [PFCloud callFunctionInBackground:@"createStripePayment" withParameters:params block:^(NSArray *results, NSError *error) {
        if (error) {
            [self showStripeError:error];
        } else {
            [self showSuccessPage];
        }
    }];
}

- (void)showSuccessPage
{
    // Thank you page
    BNSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNSuccessViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    self.navigationItem.hidesBackButton = YES;
}

- (void)showStripeError:(NSError *)error
{
    if ([error.domain isEqualToString:@"Stripe"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error.userInfo objectForKey:@"message"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        /* Handle network error here */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error.userInfo objectForKey:@"message"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Stripe VC Error: %@", error);
    }
}

/*
- (void)addDonationToUser:(StripeResponse *)response
{
    PFUser *user = [PFUser currentUser];
    
    Donation *donation = [Donation object];
    donation.amount = response.amount;
    donation.date = response.createdAt;
    
    [donation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) { NSLog(@"Donation saved"); }
        Card *card = [Card object];
        card.number = response.card.number;
        card.expiryMonth = response.card.expiryMonth;
        card.expiryYear = response.card.expiryYear;
        card.securityCode = response.card.securityCode;
        card.name = response.card.name;
        card.addressLine1 = response.card.addressLine1;
        card.addressLine2 = response.card.addressLine2;
        card.addressZip = response.card.addressZip;
        card.addressState = response.card.addressState;
        card.addressCountry = response.card.addressCountry;
        card.country = response.card.country;
        card.cvcCheck = response.card.cvcCheck;
        card.lastFourDigits = response.card.lastFourDigits;
        card.type = response.card.type;
        [card saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!error) { NSLog(@"Card saved"); }
            
            PFRelation *cardRelation = [donation relationforKey:@"card"];
            [cardRelation addObject:card];
            [donation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                PFRelation *donationRelation = [user relationforKey:@"donations"];
                [donationRelation addObject:donation];
                if (!error) {
                    if (!error) { NSLog(@"Card-donation relation saved"); }
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        // finished
                        if (!error) {
                            if (!error) { NSLog(@"Donation-user relations saved."); }
                        } else {
                            NSLog(@"Error signing up user: %@", error);
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[error userInfo] valueForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                } else {
                    NSLog(@"Error signing up user: %@", error);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[error userInfo] valueForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }];
            
        }];
    }];
}
 */

@end
