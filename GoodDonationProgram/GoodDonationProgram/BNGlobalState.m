//
//  BNGlobalState.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/21/12.
//
//

#import "BNGlobalState.h"
#import "BNBlockingView.h"

@interface BNGlobalState()

@property (nonatomic, strong) BNBlockingView *blockingView;

@end

@implementation BNGlobalState

static BNGlobalState     *_sharedManager   = nil;
static CLLocationManager *_locationManager = nil;

+ (void)initialize
{
    if (self == [BNGlobalState class]) {
        _sharedManager   = [[self alloc] init];
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        [NSThread detachNewThreadSelector:@selector(initializePayPal)
                                 toTarget:self withObject:nil];
    }
}

+ (id)sharedManager
{
    return _sharedManager;
}

+ (CLLocationManager *)locationManager {
    return _locationManager;
}

+ (void)initializePayPal
{
//    [PayPal initializeWithAppID:(kPayPalIsSandbox ? kPayPalSandboxAppId : kPayPalLiveAppId)  forEnvironment:(kPayPalIsSandbox ? ENV_SANDBOX : ENV_LIVE)];
}

- (BOOL)isLoggedIn
{
    if ([[PFUser currentUser] isAuthenticated])
    {
        return YES;
    } else {
        return NO;
    }
}

- (void)showBlockingViewWithMessage:(NSString *)message {
    if (!_blockingView) {
        _blockingView = [[BNBlockingView alloc] initWithFrame:CGRectMake(110., 200., 120., 100.)];
    }
    [_blockingView setMessage:message];
    [_blockingView show];
}

- (void)hideBlockingView {
    [_blockingView hide];
}

- (void)getAllFavoritesCompletion:(void (^)(NSArray *))completionHandler
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"favoriteOrganizations"];
    
    PFQuery *query = relation.query;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.userFavorites = [objects mutableCopy];
        completionHandler(objects);
    }];
}

@end
