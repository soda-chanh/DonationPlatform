//
//  BNLocationViewController.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/17/12.
//
//

#import "BNLocationViewController.h"
#import "BNGlobalState.h"

@interface BNLocationViewController ()

@property (nonatomic, strong) CLLocation                 *location;

@property (nonatomic, strong) IBOutlet UITextField       *zipCodeTextfield;

@end

@implementation BNLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do we need this?
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
//    {
        self.location = [self getLocation];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreLocation

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized)
    {
        self.location = [self getLocation];
        [self performSegueWithIdentifier:@"ContinueWithLocation" sender:self];
    }
}

- (CLLocation *)getLocation
{
    CLLocationManager *locationManager = [BNGlobalState locationManager];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    CLLocation *location = locationManager.location;
    NSLog(@"Location = %@", location);
    return location;
}

#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
