//
//  BNLoginViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/29/13.
//
//

#import "BNLoginViewController.h"
#import <Parse/Parse.h>
#import "BNRegistrationViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "BNStripeViewController.h"

@interface BNLoginViewController ()

@property (weak,   nonatomic) IBOutlet UIScrollView             *scrollView;
@property (weak,   nonatomic) IBOutlet UITextField              *emailTextfield;
@property (weak,   nonatomic) IBOutlet UITextField              *pinTextfield;
@property (strong, nonatomic)          UITextField              *currentTextfield;
@property (strong, nonatomic) IBOutlet UIButton                 *signupButton;
@property (strong, nonatomic) IBOutlet UIButton                 *giveAnonymouslyButton;
@property (strong, nonatomic)          UITapGestureRecognizer   *gestureRecognizer;
@property (strong, nonatomic)          NSMutableArray           *allTextfields;

@end

@implementation BNLoginViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationButtons];
    [self setupKeyboardNavigationButtons];
    
    UIFont *font = [UIFont fontWithName:@"BryantPro-Medium" size:14.0];
    self.giveAnonymouslyButton.titleLabel.font = font;
    self.signupButton.titleLabel.font = font;
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _emailTextfield.text = @"";
    _pinTextfield.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupKeyboardNavigationButtons
{
    _allTextfields = [NSMutableArray array];
    [_allTextfields addObject:_emailTextfield];
    [_allTextfields addObject:_pinTextfield];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(prevTextfield:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextfield:)];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:prevButton, nextButton, flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    
    [_emailTextfield setInputAccessoryView:toolbar];
    [_pinTextfield setInputAccessoryView:toolbar];
}


#pragma mark - IBAction

- (IBAction)loginPressed:(id)sender
{
    // validate
    [PFUser logInWithUsernameInBackground:_emailTextfield.text password:_pinTextfield.text block:^(PFUser *user, NSError *error) {
        if (error)
        {
            _pinTextfield.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Wrong username/password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            [[BNGlobalState sharedManager] setCurrentUser:user];
            BNStripeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNStripeViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (IBAction)signupWithEmailPressed:(id)sender
{
    BNRegistrationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNRegistrationViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)giveAnonymouslyPressed:(id)sender
{
    BNStripeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNStripeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Facebook



- (IBAction)signUpWithFacebook:(id)sender
{
    NSLog(@"Pressed Facebook button");
    [[BNGlobalState sharedManager] showBlockingViewWithMessage:@"Waiting for Facebook..."];
    NSArray *permissionsArray = @[@"email", @"user_birthday"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        [[BNGlobalState sharedManager] hideBlockingView];
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
}

- (void)loginSuccessful
{
    [[BNGlobalState sharedManager] setCurrentUser:[PFUser currentUser]];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:[[BNGlobalState sharedManager] pendingViewController]];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)requestUserInfo
{
    // Issue a Facebook Graph API request to get your user's friend list
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // NSArray *friendUsers = [friendQuery findObjects];
        }
    }];
}



#pragma mark - Helper Functions


- (id)objectValueIgnoringNSNULL:(id)objectValue
{
    return (objectValue ? objectValue : [[NSNull alloc] init]);
}



#pragma mark - UITextField


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextfield = textField;
    [self.view addGestureRecognizer:self.gestureRecognizer];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view removeGestureRecognizer:self.gestureRecognizer];
}

- (void)dismissKeyboard:(id)sender
{
    [_currentTextfield resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginPressed:nil];
    return YES;
}

- (void)prevTextfield:(id)sender
{
    NSUInteger index = [_allTextfields indexOfObject:_currentTextfield];
    
    NSUInteger prevIndex;
    if (index > 0)
        prevIndex = index-1;
    else
        prevIndex =_allTextfields.count - 1;
    
    [[_allTextfields objectAtIndex:prevIndex] becomeFirstResponder];
}

- (void)nextTextfield:(id)sender
{
    NSUInteger index = [_allTextfields indexOfObject:_currentTextfield];
    NSUInteger nextIndex = 0;
    if (index < _allTextfields.count-1)
        nextIndex = index+1;
    [[_allTextfields objectAtIndex:nextIndex] becomeFirstResponder];
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
    
    CGPoint cp = [_currentTextfield convertPoint:_currentTextfield.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    cp.y += _currentTextfield.frame.size.height;
    
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
