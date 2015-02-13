//
//  BNBlockingView.m
//  GoodDonationProgram
//
//  Created by Stacey Dao on 11/24/13.
//
//

#import "BNBlockingView.h"

@interface BNBlockingView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation BNBlockingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 8.;
        self.alpha = .8f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10., 50., 100., 50.)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"BryantPro-Medium" size:14.0f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _label = label;
        [self addSubview:label];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(0, 0, 120, 50);
        _activityView = activityView;
        [self addSubview:activityView];
    }
    return self;
}

- (void)setMessage:(NSString *)message
{
    self.label.text = message;
}

- (void)show {
    UIView *view = [[BNGlobalState sharedManager] navigationController].view;
    [view addSubview:self];
    view.userInteractionEnabled = NO;
    [self.activityView startAnimating];
}

- (void)hide {
    UIView *view = [[BNGlobalState sharedManager] navigationController].view;
    view.userInteractionEnabled = YES;
    [self.activityView stopAnimating];
    [self removeFromSuperview];
}

@end
