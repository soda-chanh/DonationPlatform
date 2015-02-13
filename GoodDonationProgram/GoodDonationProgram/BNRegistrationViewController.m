//
//  BNRegistrationViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/29/13.
//
//

#import "BNRegistrationViewController.h"
#import "BNStripeViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "BNGlobalState.h"
#import "BNSuccessViewController.h"
#import "UIAlertView+Blocks.h"
#import "User.h"
#import "AESCrypt.h"
#import "BNStripeViewController.h"
#import "BNLoginViewController.h"

@interface BNRegistrationViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextField *firstNameTextfield;
@property (nonatomic, strong) IBOutlet UITextField *lastNameTextfield;
@property (nonatomic, strong) IBOutlet UITextField *emailTextfield;
@property (nonatomic, strong) IBOutlet UITextField *pinTextfield;
@property (nonatomic, strong) IBOutlet UITextField *reenterPinTextfield;
@property (nonatomic, strong)          UITextField *currentTextField;
@property (nonatomic, strong)          NSMutableArray *allTextfields;
@property (nonatomic, strong) IBOutlet UIButton *signupButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *giveAnonymouslyButton;

@property (nonatomic, strong)          UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong)          NSString    *errorMessage;

@end

@implementation BNRegistrationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard:)  name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, remove this line to switch to live.

//#ifdef DEBUG
//    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentProduction];
//    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
//#else
//    NSLog(@"Paypal is on production..!!!  SHOULD NEVER SEE THIS");
////    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentProduction];
//#endif
//    [PayPalPaymentViewController prepareForPaymentUsingClientId:kPayPalClientId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationButtons];
    [self setupKeyboardNavigationButtons];
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    
    UIFont *font = [UIFont fontWithName:@"BryantPro-Medium" size:14.0];
    self.signupButton.titleLabel.font = font;
    self.firstNameTextfield.font = font;
    self.lastNameTextfield.font = font;
    self.emailTextfield.font = font;
    self.pinTextfield.font = font;
    self.reenterPinTextfield.font = font;
    
    self.loginButton.titleLabel.font = font;
    self.signupButton.titleLabel.font = font;
    self.giveAnonymouslyButton.titleLabel.font = font;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupKeyboardNavigationButtons
{
    _allTextfields = [NSMutableArray array];
    [_allTextfields addObject:_firstNameTextfield];
    [_allTextfields addObject:_lastNameTextfield];
    [_allTextfields addObject:_emailTextfield];
    [_allTextfields addObject:_pinTextfield];
    [_allTextfields addObject:_reenterPinTextfield];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(prevTextfield:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextfield:)];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:prevButton, nextButton, flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    
    [_firstNameTextfield setInputAccessoryView:toolbar];
    [_lastNameTextfield setInputAccessoryView:toolbar];
    [_pinTextfield setInputAccessoryView:toolbar];
    [_reenterPinTextfield setInputAccessoryView:toolbar];
    [_emailTextfield setInputAccessoryView:toolbar];
}


/*
- (void)setupPaypal
{
    PayPalInitializationStatus status = [PayPal initializationStatus];
    if (status == STATUS_COMPLETED_SUCCESS) {
        //We have successfully initialized and are ready to pay
    } else if (status == STATUS_COMPLETED_ERROR){
        //An error occurred, valid attempt for re-try
        [BNGlobalState initializePayPal];
    }
    
    _paypalButton = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:@selector(paypalPressed:) andButtonType:BUTTON_194x37 andButtonText:BUTTON_TEXT_DONATE];
    [self.view addSubview:_paypalButton];
    
    _paypalButton.frame = CGRectMake(64, 455, 194, 37);
}
*/
- (BOOL)verifyForm
{
    _errorMessage = nil;
    if (_firstNameTextfield.text.length < 1) {
        _errorMessage = @"First name is required.";
    } else if (_lastNameTextfield.text.length < 1) {
        _errorMessage = @"Last name is required.";
    } else if (_emailTextfield.text.length < 1) {
        _errorMessage = @"Email is required.";
    } else if (_pinTextfield.text.length < 4) {
        _errorMessage = @"A 4-digit PIN required.";
    } else if (![_reenterPinTextfield.text isEqualToString:_pinTextfield.text]) {
        _errorMessage = @"PIN fields do not match.";
    }
    return (_errorMessage ? NO : YES);
}

- (IBAction)signup:(id)sender
{
    if ([self verifyForm]) {
        [self createAccount];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:_errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)createAccount
{
    User *newUser = [[User alloc] init];
    newUser.first_name = _firstNameTextfield.text;
    newUser.last_name = _lastNameTextfield.text;
    newUser.email = _emailTextfield.text;
    newUser.username = _emailTextfield.text;
    
    NSString *encryptedPin = [AESCrypt encrypt:_pinTextfield.text password:kEncryptionPassword];
    newUser.pin = encryptedPin;
    newUser.password = _pinTextfield.text;
    
    // Save the new post
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Signed up new user.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Account successfully created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert showAlerViewFromButtonAction:nil animated:YES handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                BNStripeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNStripeViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            NSLog(@"Error signing up user: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[error userInfo] valueForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


#pragma mark - IBAction


- (IBAction)signupWithEmailPressed:(id)sender
{
    BNLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNLoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)giveAnonymouslyPressed:(id)sender
{
    BNStripeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNStripeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}



/*
- (void)showPayPalView
{
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.recipient = kGoodDonationProgramRecipientEmail;
	payment.paymentCurrency = @"USD";
	payment.description = @"Donation";
	payment.merchantName = @"Good Donation Program";
	payment.subTotal = [[BNGlobalState sharedManager] pendingAmount];
    
    [[PayPal getPayPalInst] checkoutWithPayment:payment];
}
*/


/*
#pragma mark - PayPal

- (IBAction)showPayPalView {
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"39.95"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Awesome saws";
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }

    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    // Provide a payerId that uniquely identifies a user within the scope of your system,
    // such as an email address or user ID.
    NSString *aPayerId = @"someuser@somedomain.com";
    
    // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
    // from the previous step, and a PayPalPaymentDelegate to handle the results.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:kPayPalClientId
                                                                    receiverEmail:kPayPalReceiverEmail
                                                                          payerId:aPayerId
                                                                          payment:payment
                                                                         delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    BNSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNSuccessViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payPalPaymentDidCancel {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
//    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
//                                                           options:0
//                                                             error:nil];
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

*/
/*
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus
{
    NSLog(@"Payment successful with key %@, and status %i", payKey, paymentStatus);
    
    BNSuccessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNSuccessViewController"];
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
}*/


#pragma mark - UITextField delegate

- (void)dismissKeyboard:(id)sender
{
    [_currentTextField resignFirstResponder];
    [self.view removeGestureRecognizer:self.gestureRecognizer];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    [self.view addGestureRecognizer:self.gestureRecognizer];
    return YES;
}

- (void)prevTextfield:(id)sender
{
    NSUInteger index = [_allTextfields indexOfObject:_currentTextField];
    
    NSUInteger prevIndex;
    if (index > 0)
        prevIndex = index-1;
    else
        prevIndex =_allTextfields.count - 1;
    
    [[_allTextfields objectAtIndex:prevIndex] becomeFirstResponder];
}

- (void)nextTextfield:(id)sender
{
    NSUInteger index = [_allTextfields indexOfObject:_currentTextField];
    NSUInteger nextIndex = 0;
    if (index < _allTextfields.count-1)
        nextIndex = index+1;
    [[_allTextfields objectAtIndex:nextIndex] becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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


@end
