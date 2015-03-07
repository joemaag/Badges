//
//  CategoryTableViewCell.h
//  Badges
//
//  Created by Joseph Maag on 2/24/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;
@property (weak, nonatomic) IBOutlet UITextView *categoryDescriptionTextView;

@end
