//
//  BNNearbyViewController.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BNNearbyViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (id)initWithStoryboard:(UIStoryboard *)storyboard;

@end
