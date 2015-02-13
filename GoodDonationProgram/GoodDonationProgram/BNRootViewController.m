//
//  BNRootViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/25/13.
//
//

#import "BNRootViewController.h"
#import "BNNearbyViewController.h"
#import "BNCategoriesViewController.h"
#import "BNFavoritesViewController.h"
#import "BNProfileViewController.h"
#import "UIViewController+CustomNavigationItems.h"

#define kSegmentNearbyIndex    0
#define kSegmentAllIndex       1
#define kSegmentFavoritexIndex 2

//#define kRootViewControllerSubFrame    CGRectMake(0, 46, 320, 414)

@interface BNRootViewController ()

@property (nonatomic, strong) IBOutlet UIView             *currentView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) BNNearbyViewController      *nearbyVC;
@property (nonatomic, strong) BNCategoriesViewController  *categoriesVC;
@property (nonatomic, strong) BNFavoritesViewController   *favoritesVC;

@end

@implementation BNRootViewController
{
    CGRect subviewFrame;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[BNGlobalState sharedManager] setNavigationController:self.navigationController];
    
    _nearbyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BNNearbyViewController"];
    _categoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BNCategoriesViewController"];
    _categoriesVC.delegate = self;
    _favoritesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BNFavoritesViewController"];

    [self addChildViewController:_nearbyVC];
    [self addChildViewController:_categoriesVC];
    [self addChildViewController:_favoritesVC];
    
    subviewFrame = _currentView.frame;
    [self.view addSubview:_nearbyVC.view];
    _currentView = _nearbyVC.view;
    
    _nearbyVC.view.frame = subviewFrame;
    _categoriesVC.view.frame = subviewFrame;
    _favoritesVC.view.frame = subviewFrame;
    
    [self setupNavigationButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlValueChanged:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSUInteger selectedIndex = [segmentedControl selectedSegmentIndex];
    
    [_nearbyVC.view removeFromSuperview];
    [_categoriesVC.view removeFromSuperview];
    [_favoritesVC.view removeFromSuperview];

    switch (selectedIndex) {
        case kSegmentNearbyIndex:
            [self.view addSubview:_nearbyVC.view];
            break;
        case kSegmentAllIndex:
            [self.view addSubview:_categoriesVC.view];
            break;
        case kSegmentFavoritexIndex:
            [self.view addSubview:_favoritesVC.view];
            break;
            
        default:
            break;
    }
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
