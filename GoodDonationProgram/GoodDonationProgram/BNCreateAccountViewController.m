//
//  BNCreateAccountViewController.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/9/12.
//  Copyright (c) 2012 BegNoMore. All rights reserved.
//

#import "BNCreateAccountViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "BNGlobalState.h"
//#import "PayPalPayment.h"
#import "BNConfirmationViewController.h"

@interface BNCreateAccountViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIView *activityView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIButton  *paypalButton;

//@property (nonatomic, strong) IBOutlet UITextField  *firstNameTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *lastNameTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *emailTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *birthdayTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *genderTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *streetTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *cityTextField;
//@property (nonatomic, strong) IBOutlet UITextField  *stateTextField;
//
//@property (nonatomic, strong) NSString *firstName;
//@property (nonatomic, strong) NSString *lastName;
//@property (nonatomic, strong) NSString *email;
//@property (nonatomic, strong) NSString *birthday;
//@property (nonatomic, strong) NSString *gender;
//@property (nonatomic, strong) NSString *street;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *state;
//
//@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation BNCreateAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard:)  name:UIKeyboardDidHideNotification object:nil];*/
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    _activityView.layer.cornerRadius = 10;
    
    [self hideActivityIndicator];
    
    /*
    PayPalInitializationStatus status = [PayPal initializationStatus];
    if (status == STATUS_COMPLETED_SUCCESS) {
        //We have successfully initialized and are ready to pay
    } else if (status == STATUS_COMPLETED_ERROR){
        //An error occurred, valid attempt for re-try
        [BNGlobalState initializePayPal];
    }
    
    _paypalButton = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:@selector(pressedPayButton:) andButtonType:BUTTON_194x37 andButtonText:BUTTON_TEXT_DONATE];
    [self.view addSubview:_paypalButton];
    */
    
    _paypalButton.frame = CGRectMake(76, 210, 194, 37);
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
//    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Facebook

- (IBAction)signUpWithFacebook:(id)sender
{
    NSArray *permissionsArray = @[@"email", @"user_birthday"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self createUser];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self loginSuccessful];
        }
    }];

    [self showActivityIndicator];
}

- (void)hideActivityIndicator
{
    [_activityIndicator stopAnimating]; // Hide loading indicator
    _activityView.hidden = YES;
}

- (void)showActivityIndicator
{
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
    _activityView.hidden = NO;
}

- (void)createUser
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // Store the current user's Facebook ID on the user
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"id"]]
                                     forKey:@"fbId"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"birthday"]]
                                     forKey:@"birthday"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"first_name"]]
                                     forKey:@"first_name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"last_name"]]
                                     forKey:@"last_name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"location"]]                                     forKey:@"location"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"middle_name"]]
                                     forKey:@"middle_name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"name"]]
                                     forKey:@"name"];
            [[PFUser currentUser] setObject:[self objectValueIgnoringNSNULL:[result objectForKey:@"username"]]
                                     forKey:@"username"];
            [[PFUser currentUser] saveInBackground];
            
//            [self requestUserInfo];
        }
    }];
}

- (void)loginSuccessful
{
    
}

- (void)requestUserInfo
{
    // Issue a Facebook Graph API request to get your user's friend list
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
//            NSArray *friendUsers = [friendQuery findObjects];
        }
    }];
}
/*

#pragma mark - PayPal

- (void)pressedPayButton:(id)sender
{
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.recipient = kGoodDonationProgramRecipientEmail;
	payment.paymentCurrency = @"USD";
	payment.description = @"Donation";
	payment.merchantName = @"Good Donation Program";
	payment.subTotal = [[BNGlobalState sharedManager] pendingAmount];
    
    [[PayPal getPayPalInst] checkoutWithPayment:payment];
}

- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus
{
    NSLog(@"Payment successful with key %@, and status %i", payKey, paymentStatus);
    
    BNConfirmationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmationViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)paymentCanceled
{
    NSLog(@"Payment cancelled");
}

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID
{
    NSLog(@"Payment failed with correlation id %@", correlationID);
}

- (void)paymentLibraryExit
{
    NSLog(@"Payment library exit");
}
*/


#pragma mark - Keyboard
/*
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
    if (textField == _firstNameTextField)
        _firstName = textField.text;
    else if (textField == _lastNameTextField)
        _lastName = textField.text;
    else if (textField == _emailTextField)
        _email = textField.text;
    else if (textField == _birthdayTextField)
        _birthday = textField.text;
    else if (textField == _genderTextField)
        _gender = textField.text;
    else if (textField == _streetTextField)
        _street = textField.text;
    else if (textField == _cityTextField)
        _city = textField.text;
    else if (textField == _stateTextField)
        _state = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
*/

#pragma mark - Helper Functions

- (id)objectValueIgnoringNSNULL:(id)objectValue
{
    return (objectValue ? objectValue : [[NSNull alloc] init]);
}

@end
