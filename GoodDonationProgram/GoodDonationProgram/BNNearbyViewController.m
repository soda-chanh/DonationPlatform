//
//  BNNearbyViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import "BNNearbyViewController.h"
#import <Parse/Parse.h>
#import "BNGlobalState.h"
#import "Organization.h"
#import "BNOrganizationCell.h"
#import "BNOrganizationViewController.h"
#import "BNAnnotation.h"

@interface BNNearbyViewController ()

@property (nonatomic, strong) NSArray *organizations;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIScrollView *listScrollView;
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) BOOL isFinishedLoadingFavorites;

@end

@implementation BNNearbyViewController

- (id)initWithStoryboard:(UIStoryboard *)storyboard
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listScrollView.alpha = 0.;
    _locationManager = [BNGlobalState locationManager];
    _locationManager.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self startLocationServices];
    [self loadNearby];
    
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Anonymous login failed.");
        } else {
            NSLog(@"Anonymous user logged in.");
            [self loadFavorites];
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableView reloadData];
}


- (void)startLocationServices
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"To use the Nearby Feature, Please enable Location Services under Settings" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        [_locationManager startUpdatingLocation];
    }
}


- (void)loadNearby
{
    // Load category types
    PFQuery *query = [PFQuery queryWithClassName:kOrganization];
    __weak BNNearbyViewController *selfRef = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu organizations.", (unsigned long)objects.count);
            selfRef.organizations = objects;
            [selfRef.tableView reloadData];
            [self annotateMap];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFavorites
{
    __weak BNNearbyViewController *selfRef = self;
    [[BNGlobalState sharedManager] getAllFavoritesCompletion:^(NSArray *favorites) {
        self.isFinishedLoadingFavorites = YES;
        [selfRef.tableView reloadData];
    }];
}

- (IBAction)toggleButtonPressed:(id)sender
{
    NSString *title = self.toggleButton.titleLabel.text;
    if ([title isEqualToString:@"List"]) {
        title = @"Map";
        self.listScrollView.alpha = 1.;
        self.mapView.alpha = 0.;
    } else {
        title = @"List";
        self.mapView.alpha = 1.;
        self.listScrollView.alpha = 0.;
    }
    [self.toggleButton setTitle:title forState:UIControlStateNormal];
}

- (void)annotateMap
{
    Organization *firstOrg = [_organizations objectAtIndex:0];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(firstOrg.latitude.floatValue, firstOrg.longitude.floatValue);
    CLLocationCoordinate2D upperBound = location;
    CLLocationCoordinate2D lowerBound = location;
    
    _annotations = [NSMutableArray array];
    for (Organization *org in _organizations)
    {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(org.latitude.floatValue, org.longitude.floatValue);
    
        if(location.latitude > upperBound.latitude) {
            upperBound.latitude = location.latitude;
        }
        
        if(location.latitude < lowerBound.latitude) {
            lowerBound.latitude = location.latitude;
        }
        
        if(location.longitude > upperBound.longitude) {
            upperBound.longitude = location.longitude;
        }
        
        if(location.longitude < lowerBound.longitude) {
            lowerBound.longitude = location.longitude;
        }
        
        MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
        newAnnotation.title = org.organizationName;
        newAnnotation.coordinate = location;
        [_annotations addObject:newAnnotation];
    }
    
    
    // FIND REGION
    MKCoordinateSpan locationSpan;
    locationSpan.latitudeDelta = upperBound.latitude - lowerBound.latitude;
    locationSpan.longitudeDelta = upperBound.longitude - lowerBound.longitude;
    CLLocationCoordinate2D locationCenter;
    locationCenter.latitude = (upperBound.latitude + lowerBound.latitude) / 2;
    locationCenter.longitude = (upperBound.longitude + lowerBound.longitude) / 2;
    [_mapView addAnnotations:_annotations];
    [self.mapView setRegion:MKCoordinateRegionMake(locationCenter, locationSpan)];
}

#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _organizations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Organization *organization = [_organizations objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"BNOrganizationCell";
    BNOrganizationCell *cell = (BNOrganizationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.favoriteButton.hidden = !self.isFinishedLoadingFavorites;
    [cell configureWithOrganization:organization];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNOrganizationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNOrganizationViewController"];
    vc.organization = [self.organizations objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - CoreLocation

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized)
    {
        self.location = [self getLocation];
    }
}

- (CLLocation *)getLocation
{
    [_locationManager startUpdatingLocation];
    CLLocation *location = _locationManager.location;
    NSLog(@"Location = %@", location);
    return location;
}

#pragma mark - MKMapView


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = nil;
    static NSString *annotationViewIdentifier = @"annotationViewIdentifier";
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return annotationView;
    }
    else {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
        }
        [annotationView setCanShowCallout:YES];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.animatesDrop = YES;
        annotationView.annotation = annotation;
        annotationView.centerOffset = CGPointMake(0.f, -10.f);
        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Unhighlight previous cell
    if (self.selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    // Highlight new cell
    Organization *org = [self organizationForAnnotation:view.annotation];
    NSUInteger index = [self.organizations indexOfObject:org];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    self.selectedIndexPath = indexPath;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    for (int i = 0; i < _annotations.count; i++)
    {
        id<MKAnnotation> a = [_annotations objectAtIndex:i];
        if ([view.annotation isEqual:a])
        {
            Organization *org = [_organizations objectAtIndex:i];
            BNOrganizationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNOrganizationViewController"];
            vc.organization = org;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (Organization *)organizationForAnnotation:(id<MKAnnotation>)annotation {
    for (int i = 0; i < _annotations.count; i++)
    {
        id<MKAnnotation> a = [_annotations objectAtIndex:i];
        if ([annotation isEqual:a])
        {
            Organization *org = [_organizations objectAtIndex:i];
            return org;
        }
    }
    return nil;
}

@end
