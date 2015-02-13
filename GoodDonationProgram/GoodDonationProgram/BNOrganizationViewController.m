//
//  BNOrganizationViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import "BNOrganizationViewController.h"
#import "BNDonateViewController.h"
#import "UIViewController+CustomNavigationItems.h"
#import <Parse/Parse.h>
#import "BNCampaignTableViewDelegate.h"
#import "BNNewsTableViewDelegate.h"


@interface BNOrganizationViewController ()

@property (nonatomic, weak)   IBOutlet UIImageView    *imageView;
@property (nonatomic, weak)   IBOutlet UILabel        *nameLabel;
@property (nonatomic, weak)   IBOutlet UITextView     *description;
@property (nonatomic, weak)   IBOutlet UIButton       *favoriteButton;
@property (nonatomic, weak)   IBOutlet UIView         *view1;
@property (nonatomic, weak)   IBOutlet UIView         *view2;
@property (nonatomic, weak)   IBOutlet UIView         *view3;
@property (nonatomic, weak)   IBOutlet UIScrollView   *scrollView;
@property (nonatomic, weak)   IBOutlet UIPageControl  *pageControl;
@property (nonatomic, weak)   IBOutlet UIView      *gradientView;
@property (nonatomic, strong)          NSMutableArray *views;
@property (nonatomic, assign)          NSUInteger   page;
@property (nonatomic, assign)          BOOL            pageControlUsed;
@property (nonatomic, assign)          BOOL            rotating;
@property (nonatomic, strong)          BNCampaignTableViewDelegate *campaignDelegate;
@property (nonatomic, strong) IBOutlet UITableView    *campaignTableView;
@property (nonatomic, strong)          BNNewsTableViewDelegate *newsDelegate;
@property (nonatomic, strong) IBOutlet UITableView    *newsTableView;

@end

@implementation BNOrganizationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.views = [NSMutableArray array];
    [_views addObject:_view1];
    [_views addObject:_view2];
    [_views addObject:_view3];

    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_organization loadImageWithCompletion:^(UIImage *image, NSError *error) {
        self.imageView.image = image;
    }];
    self.description.text = _organization.about;
    self.nameLabel.text   = _organization.organizationName;
    [self setupNavigationButtons];
    
    [self updateFavoriteButton];
    
    self.campaignDelegate = [[BNCampaignTableViewDelegate alloc] init];
    self.campaignTableView.dataSource = self.campaignDelegate;
    self.campaignTableView.delegate = self.campaignDelegate;
    self.newsDelegate = [[BNNewsTableViewDelegate alloc] init];
    self.newsTableView.dataSource = self.newsDelegate;
    self.newsTableView.delegate = self.newsDelegate;
    [self stylizeView];
    [self loadCampaigns];
    [self loadNews];
}

- (void)updateFavoriteButton
{
    if (_organization.isFavorite) {
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite-selected"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
	return NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	for (NSInteger i = 0; i < [self.views count]; i++) {
		[self loadScrollViewWithPage:i];
	}
    
	self.pageControl.currentPage = 0;
	_page = 0;
	[self.pageControl setNumberOfPages:[self.views count]];
    
	UIView *view = [self.views objectAtIndex:self.pageControl.currentPage];
	if (view.superview != nil) {
		view.hidden = NO;
	}
    
	self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [self.views count], _scrollView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	UIView *view = [self.views objectAtIndex:self.pageControl.currentPage];
	if (view.superview != nil) {
		view.hidden = NO;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	UIView *view = [self.views objectAtIndex:self.pageControl.currentPage];
	if (view.superview != nil) {
		view.hidden = YES;
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIView *view = [self.views objectAtIndex:self.pageControl.currentPage];
	if (view.superview != nil) {
		view.hidden = YES;
	}
	[super viewDidDisappear:animated];
}

- (void)stylizeView
{
    // Fade-out Gradient
    NSNumber *s3 = [NSNumber numberWithFloat:.4];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.92];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:s3, stopTwo, stopFour, nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.gradientView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.0].CGColor,
                            (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor, nil];
    gradientLayer.locations = locations;
    [self.gradientView.layer addSublayer:gradientLayer];
    self.description.font = [UIFont fontWithName:@"BryantPro-Medium" size:14.];
}

- (void)loadCampaigns
{
    PFQuery *query = [PFQuery queryWithClassName:@"Campaign"];
    [query whereKey:@"organization" equalTo:self.organization];
    [query findObjectsInBackgroundWithBlock:^(NSArray *campaigns, NSError *error) {
        self.campaignDelegate.campaigns = campaigns;
        [self.campaignTableView reloadData];
    }];
}

- (void)loadNews
{
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query whereKey:@"organization" equalTo:self.organization];
    [query findObjectsInBackgroundWithBlock:^(NSArray *news, NSError *error) {
        self.newsDelegate.news = news;
        [self.newsTableView reloadData];
    }];
}

- (void)loadOrganizationForDonation:(Donation *)donation
{
    PFRelation *relation = donation.organization;
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *organizations, NSError *error) {
        _organization = organizations[0];
    }];
}


#pragma mark - IBAction


- (IBAction)donateButtonPressed:(id)sender
{
    [[BNGlobalState sharedManager] setPendingOrganization:self.organization];
    BNDonateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNDonateViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)favoriteButtonPressed:(id)sender
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"favoriteOrganizations"];
    
    if (_organization.isFavorite)
    {
        NSLog(@"Attempting: Remove favorite.");
        [relation removeObject:_organization];
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Removed favorite.");
        }];
    } else {
        NSLog(@"Attempting: Save favorite.");
        [relation addObject:_organization];
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite-selected"] forState:UIControlStateNormal];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Saved favorite.");
        }];
    }
}


#pragma mark - Page Scroll


- (void)loadScrollViewWithPage:(NSInteger)page {
    if (page < 0)
        return;
    if (page >= [self.views count])
        return;
    
	// replace the placeholder if necessary
    UIView *view = [self.views objectAtIndex:page];
    if (view == nil) {
		return;
    }
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    view.frame = frame;
    
	// add the controller's view to the scroll view
    if (view.superview == nil) {
        [self.scrollView addSubview:view];
    }
}

- (IBAction)changePage:(id)sender {
    NSUInteger page = ((UIPageControl *)sender).currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIView *oldView = [self.views objectAtIndex:_page];
    UIView *newView = [self.views objectAtIndex:self.pageControl.currentPage];
    oldView.hidden = YES;
    newView.hidden = NO;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed || _rotating) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage != page) {
        UIView *oldView = [self.views objectAtIndex:self.pageControl.currentPage];
        UIView *newView = [self.views objectAtIndex:page];
//        [oldViewController viewWillDisappear:YES];
//        [newView viewWillAppear:YES];
        self.pageControl.currentPage = page;
        oldView.hidden = YES;
        newView.hidden = NO;
        _page = page;
    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    UIView *oldView = [self.views objectAtIndex:_page];
    UIView *newView = [self.views objectAtIndex:self.pageControl.currentPage];
    oldView.hidden = YES;
    newView.hidden = NO;
    
    _page = self.pageControl.currentPage;
}



@end
