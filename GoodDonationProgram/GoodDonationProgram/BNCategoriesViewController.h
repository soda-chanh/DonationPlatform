//
//  BNCategoriesViewController.h
//  GoodDonationProgram
//
//  Created by Stacey Dao on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import "BNRootViewController.h"

@interface BNCategoriesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) BNRootViewController *delegate;

- (void)reloadData;

@end
