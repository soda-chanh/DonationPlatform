//
//  UIPaymentViewController.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/21/12.
//
//

#import "BNPaymentViewController2.h"
#import <QuartzCore/QuartzCore.h>
#import "BNGlobalState.h"
#import "BNConfirmationViewController.h"

@interface BNPaymentViewController2 ()

@property (nonatomic, strong) UIButton  *paypalButton;

@end

@implementation BNPaymentViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    PayPalInitializationStatus status = [PayPal initializationStatus];
    if (status == STATUS_COMPLETED_SUCCESS) {
        //We have successfully initialized and are ready to pay
    } else if (status == STATUS_COMPLETED_ERROR){
        //An error occurred, valid attempt for re-try
        [BNGlobalState initializePayPal];
    }

    _paypalButton = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:@selector(pressedPayButton:) andButtonType:BUTTON_194x37 andButtonText:BUTTON_TEXT_DONATE];
    [self.view addSubview:_paypalButton];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - PayPal

- (void)pressedPayButton:(id)sender
{
    //
}

- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus
{
    
}

- (void)paymentCanceled
{
    
}

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID
{
    
}

- (void)paymentLibraryExit
{
    
}
*/
@end
