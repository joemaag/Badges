//
//  BadgeDetailViewController.m
//  Badges
//
//  Created by Joseph Maag on 2/23/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import "BadgeDetailViewController.h"

@interface BadgeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (nonatomic, strong) NSString *badgeTitle;
@property (nonatomic, strong) NSString *badgeDescription;
@property (nonatomic, strong) UIImage *badgeImage;
@property (nonatomic) int points;
@property (nonatomic) int categoryNumber;
@property (nonatomic) BOOL viewDidAlreadyAppear;
/* 'viewDidAlreadyAppear' is used to only allow the animation to run once and prevents the animation from running again
    when the UINavigationController's 'interactivePopGestureRecognizer' is used */

@end

@implementation BadgeDetailViewController

#pragma mark Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.badgeTitleTextView.text = self.badgeTitle;
    self.badgeDetailTextView.text = self.badgeDescription;
    self.badgeImageView.image = self.badgeImage;
    
    UIColor *categoryColor = [self uicolorForCategoryNumericalId:self.categoryNumber];
    self.badgeTitleTextView.textColor = categoryColor;
    if (self.points != 0) {
        NSMutableAttributedString *pointsString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Points: %d", self.points]];
        [pointsString addAttribute:NSForegroundColorAttributeName  value:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f] range:NSMakeRange(0, 8)];
        [pointsString addAttribute:NSForegroundColorAttributeName  value:categoryColor range:NSMakeRange(8, pointsString.length - 8)];
        self.pointsLabel.attributedText = pointsString;
    }else{
        self.pointsLabel.text = @"";
    }
    self.navigationController.navigationBar.tintColor = categoryColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.viewDidAlreadyAppear) {
        /* Move subViews to different positions so they can be animated in */
        self.badgeImageView.transform = CGAffineTransformMakeScale(0.3f, 0.5f);
        self.badgeTitleTextView.center = CGPointMake(self.badgeTitleTextView.center.x, self.badgeTitleTextView.center.y - 70.0f);
        self.badgeDetailTextView.center = CGPointMake(self.badgeDetailTextView.center.x, self.badgeDetailTextView.center.y + 120.0f);
        self.pointsLabel.center = CGPointMake(self.pointsLabel.center.x, self.pointsLabel.center.y + 120.0f);
        
        [UIView animateWithDuration:0.9f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.badgeImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.badgeTitleTextView.center = CGPointMake(self.badgeTitleTextView.center.x, self.badgeTitleTextView.center.y + 70.0f);
            self.badgeDetailTextView.center = CGPointMake(self.badgeDetailTextView.center.x, self.badgeDetailTextView.center.y - 120.0f);
            self.pointsLabel.center = CGPointMake(self.pointsLabel.center.x, self.pointsLabel.center.y - 120.0f);
        } completion:nil];
        self.viewDidAlreadyAppear = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:19/255.0f green:114/255.0f blue:221/255.0f alpha:1.0f];
}

- (void)configureWithBadge:(Badge *)badge {
    self.badgeTitle = badge.badgeDescription;
    self.badgeDescription = badge.translatedSafeExtendedDesciption;
    self.badgeImage = badge.largeIconImage;
    self.categoryNumber = [badge.category intValue];
    self.points = [badge.points intValue];
}

#pragma mark Helpers

- (UIColor *)uicolorForCategoryNumericalId:(int)categoryNumber {
    UIColor *headerColor;
    switch (categoryNumber) {
        case 0:
            headerColor = [UIColor colorWithRed:170/255.0f green:59/255.0f blue:39/255.0f alpha:1.0f];
            break;
            
        case 1:
            headerColor = [UIColor colorWithRed:22/255.0f green:98/255.0f blue:107/255.0f alpha:1.0f];
            break;
            
        case 2:
            headerColor = [UIColor colorWithRed:72/255.0f green:173/255.0f blue:101/255.0f alpha:1.0f];
            break;
            
        case 3:
            headerColor = [UIColor colorWithRed:249/255.0f green:186/255.0f blue:77/255.0f alpha:1.0f];
            break;
            
        case 4:
            headerColor = [UIColor colorWithRed:181/255.0f green:23/255.0f blue:110/255.0f alpha:1.0f];
            break;
            
        case 5:
            headerColor = [UIColor colorWithRed:87/255.0f green:125/255.0f blue:186/255.0f alpha:1.0f];
            break;
            
        default:
            headerColor = [UIColor whiteColor];
            break;
    }
    return headerColor;
}

@end
