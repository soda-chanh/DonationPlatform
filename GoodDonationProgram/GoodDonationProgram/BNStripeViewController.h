//
//  BNStripeViewController.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "Stripe.h"

@class StripeConnection, StripeResponse;

@interface BNStripeViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIToolbarDelegate>

@property (strong, nonatomic) StripeConnection *stripeConnection;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *expiryField;
@property (weak, nonatomic) IBOutlet UITextField *CVCField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
//@property (weak, nonatomic) id <STCardViewControllerDelegate>delegate;
@property (strong, nonatomic) NSArray *fields;

- (IBAction)fieldSelected:(UISegmentedControl *)control;
- (IBAction)donePressed:(id)sender;

@end
