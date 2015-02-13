//
//  BNOrganizationCell.m
//  BegNoMore
//
//  Created by Stacey Dao on 12/21/12.
//
//

#import "BNOrganizationCell.h"
#import "UIImage+Thumbnail.h"

@interface BNOrganizationCell()


@end

@implementation BNOrganizationCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithOrganization:(Organization *)org
{
    _organization = org;
    _nameLabel.text = org.organizationName;
    
    [_organization loadImageWithCompletion:^(UIImage *image, NSError *error) {
        self.pfImageView.image = image;
    }];
    
    [self updateFavoriteButton];
    
//    PFFile *imageFile = org.image;
//    self.pfImageView.file = imageFile;
//    [self.pfImageView loadInBackground:^(UIImage *image, NSError *error) {
//
//        image = [image thumbnailOfSize:self.pfImageView.frame.size];
//        self.pfImageView.image = image;
//    }];
}

- (void)updateFavoriteButton
{
    if (_organization.isFavorite) {
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite-selected"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
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
            [[[BNGlobalState sharedManager] userFavorites] removeObject:_organization];
        }];
    } else {
        NSLog(@"Attempting: Save favorite.");
        [relation addObject:_organization];
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite-selected"] forState:UIControlStateNormal];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Saved favorite.");
            [[[BNGlobalState sharedManager] userFavorites] addObject:_organization];
        }];
    }
}

@end
