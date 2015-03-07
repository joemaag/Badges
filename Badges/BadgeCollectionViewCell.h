//
//  BadgeCollectionViewCell.h
//  Badges
//
//  Created by Joseph Maag on 2/20/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UITextView *badgeTextView;

@end
