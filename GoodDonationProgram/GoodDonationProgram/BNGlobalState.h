//
//  BNGlobalState.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/21/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "PayPalMobile.h"
#import <Parse/Parse.h>
#import "Organization.h"

@interface BNGlobalState : NSObject

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSDecimalNumber *pendingAmount;
@property (nonatomic, strong) Organization *pendingOrganization;
@property (nonatomic, strong) NSString *pendingViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSMutableArray *userFavorites;

+ (id)sharedManager;
+ (CLLocationManager *)locationManager;
+ (void)initializePayPal;
- (BOOL)isLoggedIn;
- (void)showBlockingViewWithMessage:(NSString *)message;
- (void)hideBlockingView;

- (void)getAllFavoritesCompletion:(void (^)(NSArray *))completionHandler;

@end
