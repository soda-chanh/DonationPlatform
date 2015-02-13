//
//  BNOrganizationCell.h
//  BegNoMore
//
//  Created by Stacey Dao on 12/21/12.
//
//

#import <UIKit/UIKit.h>
#import "Organization.h"

@interface BNOrganizationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton     *favoriteButton;
@property (nonatomic, strong) IBOutlet PFImageView  *pfImageView;
@property (nonatomic, strong)          Organization *organization;

- (void)configureWithOrganization:(Organization *)org;
- (void)updateFavoriteButton;

@end
