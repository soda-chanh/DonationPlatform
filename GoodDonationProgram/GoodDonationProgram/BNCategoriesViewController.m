//
//  BNCategoriesViewController.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import "BNCategoriesViewController.h"
#import <Parse/Parse.h>
#import "OrganizationType.h"
#import "BNCategoryViewController.h"


@interface BNCategoriesViewController ()

@property (nonatomic, strong) NSArray                   *categories;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation BNCategoriesViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        [flowLayout setItemSize:CGSizeMake(50, 50)];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    // Configure collection
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, 320, 400) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    [self loadCategories];
}

- (void)loadCategories
{
    // Load category types
    PFQuery *query = [PFQuery queryWithClassName:kOrganizationType];
    __weak BNCategoriesViewController *selfRef = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu category types.", (unsigned long)objects.count);
            selfRef.categories = objects;
            [selfRef.collectionView reloadData];
            
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)reloadData
{
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categories.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCategoryButtonWidth, kCategoryButtonHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // add extra 10 pixels to bottom for separator and right because i don't know why it's off-centered
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"cvCell";
    OrganizationType *category = [self.categories objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[category valueForKey:kCategoryImageButtonName]]];
    imageView.frame = CGRectMake(0, 0, kCategoryButtonWidth, kCategoryButtonHeight);
    [cell addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationType *category = [self.categories objectAtIndex:indexPath.row];
    
    BNCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNCategoryViewController"];
    vc.category = category;
    [self.delegate pushViewController:vc];
//    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

@end
