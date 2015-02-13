//
//  BNPageViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 9/12/13.
//
//

#import "BNPageViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import "BNOrganizationViewController.h"

@interface BNPageViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView  *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign)          int            page;
@property (nonatomic, assign)          BOOL           pageControlUsed;
@property (nonatomic, assign)          BOOL           rotating;

@end

@implementation BNPageViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationButtons];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
