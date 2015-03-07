//
//  CategoryTableViewController.m
//  Badges
//
//  Created by Joseph Maag on 2/24/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "BadgeCategory.h"
#include "CategoryTableViewCell.h"

@implementation CategoryTableViewController

#pragma mark Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Categories";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];

}
- (void)setCategories:(NSArray *)categories {
    _categories = categories;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"categoryCell";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    BadgeCategory *category = [self.categories objectAtIndex:indexPath.row];
    cell.categoryNameLabel.text = category.name;
    cell.categoryDescriptionTextView.text = category.categoryDescription;
    /* setting the textView font because the storyboard settings stopped working...? */
    cell.categoryDescriptionTextView.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    cell.categoryDescriptionTextView.textAlignment = NSTextAlignmentCenter;
    cell.categoryDescriptionTextView.textColor = [UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:1.0f];
    cell.categoryNameLabel.textColor = [self uicolorForCategoryNumericalId:category.numberId];
    cell.categoryIconImageView.image = category.largeIconImage;
    
    return cell;
}

#pragma mark Dismissal

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Helpers

- (UIColor *)uicolorForCategoryNumericalId:(NSNumber *)categoryNumber {
    UIColor *headerColor;
    switch ([categoryNumber integerValue]) {
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
