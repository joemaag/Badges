//
//  BadgeDetailViewController.h
//  Badges
//
//  Created by Joseph Maag on 2/23/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Badge.h"

@interface BadgeDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *badgeTitleTextView;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UITextView *badgeDetailTextView;

-(void)configureWithBadge:(Badge *)badge;

@end
