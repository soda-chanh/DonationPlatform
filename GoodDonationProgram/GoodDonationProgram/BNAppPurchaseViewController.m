//
//  BNAppPurchaseViewController.m
//  BegNoMore
//
//  Created by Stacey Dao on 1/17/13.
//
//

#import "BNAppPurchaseViewController.h"
#import "BNIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface BNAppPurchaseViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray          *products;
@property (nonatomic, strong) IBOutlet UIButton         *productButton;

@end

@implementation BNAppPurchaseViewController

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
    
    self.title = @"In App Rage";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [self.refreshControl beginRefreshing];
    
}

- (void)reload {
    _products = nil;
    [[BNIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            
            self.productButton.titleLabel.text = [(SKProduct *)[products lastObject] localizedTitle];
        }
        [self.refreshControl endRefreshing];
    }];
}

@end
