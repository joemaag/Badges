//
//  BadgeGalleryViewController.m
//  Badges
//
//  Created by Joseph Maag on 2/20/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import "BadgeGalleryViewController.h"
#import "BadgeCollectionViewCell.h"
#import "Badge.h"
#import "BadgeCategory.h"
#import "DownloadManager.h"
#import "BadgeDetailViewController.h"
#import "BadgeCollectionCategoryHeader.h"
#import "CategoryTableViewController.h"

@interface BadgeGalleryViewController ()

@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) NSMutableArray *badgeCategories;
@property (nonatomic, strong) NSDictionary *badgeLibrary;
/* 'badgeLibrary' contains arrays of badges for each category.
 * They keys are NSNumbers representing the numerical ID of each category. 
 * They values of each key is an NSArray of all of the badges in that category. */
@property (nonatomic, strong) DownloadManager *downloadManager;
@property (strong, nonatomic) UILabel *loadingLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIView *fadeView;
/* fadeView sits on top of the collectionView and fades away when all of the badges are loaded */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *categoriesBarButtonItem;

@end

@implementation BadgeGalleryViewController

#pragma mark Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Badges";
    [self.downloadManager fetchBadgesAndCategories];
    [self setUpLoadingView];
    [self setUpCategoriesButton];
}


- (DownloadManager *)downloadManager {
    if (!_downloadManager) {
        _downloadManager = [DownloadManager new];
        _downloadManager.delegate = self;
    }
    return _downloadManager;
}

- (UIActivityIndicatorView *)loadingIndicator {
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }
    return _loadingIndicator;
}

- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f)];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.font = [UIFont fontWithName:@"Avenir" size:15.0f];
        _loadingLabel.text = @"Loading badges...";
    }
    return _loadingLabel;
}

- (UIView *)fadeView {
    if (!_fadeView) {
        _fadeView = [[UIView alloc]initWithFrame:self.view.frame];
        _fadeView.backgroundColor = [UIColor whiteColor];
    }
    return _fadeView;
}

- (void)setUpLoadingView {
    /* Sets up all subviews that are shown while the data is loaded */
    self.loadingIndicator.center = CGPointMake(self.view.center.x, self.view.center.y - 15.0f);
    self.loadingLabel.center =  CGPointMake(self.view.center.x, self.view.center.y + 15.0f);
    [self.view addSubview:self.fadeView];
    [self.view addSubview:self.loadingIndicator];
    [self.view addSubview:self.loadingLabel];
    [self.loadingIndicator startAnimating];
}

- (void)setUpCategoriesButton {
    [self.categoriesBarButtonItem setTarget:self];
    [self.categoriesBarButtonItem setAction:@selector(categoriesButtonPressed:)];
    self.categoriesBarButtonItem.enabled = NO;
}

- (void)removeLoadingSubviews {
    /* Animates away certain subviews when the badges are loaded */
    [UIView animateWithDuration:0.20f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loadingLabel.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
        self.loadingIndicator.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
        self.loadingIndicator.alpha = 0;
        self.loadingLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.loadingLabel removeFromSuperview];
            [self.loadingIndicator stopAnimating];
            [self.loadingIndicator removeFromSuperview];
            self.loadingLabel.alpha = 1.0f;
            self.loadingIndicator.alpha = 1.0f;
            self.categoriesBarButtonItem.enabled = YES;
            self.collectionView.contentOffset = CGPointMake(0, -10.0f);
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.fadeView.alpha = 0;
                self.collectionView.contentOffset = CGPointMake(0, -65.0f);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.fadeView removeFromSuperview];
                    /* Present alert (if we haven't already) telling the user they should touch badges */
                    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"instructionAlertShown"]) {
                        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Badge Details" message:@"Select badges to learn more about them." preferredStyle:UIAlertControllerStyleAlert];
                        [errorAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:errorAlert animated:YES completion:nil];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"instructionAlertShown"];
                    }
                }
            }];
        }
    }];
}

#pragma mark UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.badgeLibrary count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.badgeLibrary objectForKey:[NSNumber numberWithInteger:section]]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    BadgeCollectionViewCell *cell = (BadgeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Badge *badge = [[self.badgeLibrary objectForKey:[NSNumber numberWithInteger:indexPath.section]]objectAtIndex:indexPath.row];
    cell.badgeTextView.text = badge.badgeDescription;
    cell.badgeTextView.textAlignment = NSTextAlignmentCenter;
    /* Text aligned and color setting because the storyboard doesn't seem to want to do it */
    cell.badgeImageView.image = badge.smallIconImage;
    cell.badgeTextView.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
    cell.badgeTextView.font = [UIFont fontWithName:@"Avenir-Medium" size:12.0f];
    cell.layer.cornerRadius = 20.0f;
    return cell;
}

#pragma mark UICollectionView Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        BadgeCollectionCategoryHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        BadgeCategory *category = [self.badgeCategories objectAtIndex:indexPath.section];
        headerView.categoryLabel.text = category.name;
        headerView.backgroundColor = [self uicolorForCategoryNumericalId:category.numberId];
        
        return headerView;
    }
    return nil;
}

#pragma mark Badge Data Organization

- (NSMutableArray *)sortBadgesByCategoryWithBadges:(NSMutableArray *)badges {
    [badges sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Badge *b1 = (Badge *)obj1;
        Badge *b2 = (Badge *)obj2;
        if (b1.category > b2.category) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (b1.category < b2.category){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    return badges;
}

- (NSMutableArray *)sortBadgeCategoriesByNumericalValue:(NSMutableArray *)categories {
    [categories sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        BadgeCategory *category1 = (BadgeCategory *)obj1;
        BadgeCategory *category2 = (BadgeCategory *)obj2;
        if (category1.numberId > category2.numberId) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (category1.numberId < category2.numberId){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    return categories;
}

- (NSDictionary *)makeBadgeDictionaryWithBadges:(NSArray *)badges sortedByWithCategories:(NSArray *)categories {
    NSMutableDictionary *badgeLibrary = [NSMutableDictionary new];
    NSMutableArray *arraysOfBadgesForCategories = [NSMutableArray new]; /* An array of arrays. Each array represents a category, which holds all badges belonging to that category. The index of each array represents a category number */
    for (int i = 0; i < [categories count]; i++) {
        [arraysOfBadgesForCategories addObject:[NSMutableArray new]];
    }
    /* Each array in arraysOfBadgesForCategories will hold the badges that belong to that category
     * So all badges that belong to category 2 will be placed in the second array, etc.
     * This assumes the category array "categories" is in order from least to greatest (categories[0] == category 1)
     * They are in order when downloaded, but they are sorted anyway just in case (in the downloadMangerDelegate)
     */
    
    /* Assign badges to the category array they belong to */
    for (Badge *badge in badges) {
        NSMutableArray *categoryArray = [arraysOfBadgesForCategories objectAtIndex:[badge.category integerValue]];
        [categoryArray addObject:badge];
    }
    
    /* Once category arrays are filled, assign them to the library dictionary.
     * Each category key is an NSNumber of the numerical id of that category. The object at that key is the array of badges in that category
     */
    for (int count = 0; count < [arraysOfBadgesForCategories count]; count++) {
        [badgeLibrary setObject:[arraysOfBadgesForCategories objectAtIndex:count] forKey:[NSNumber numberWithInt:count]];
    }
    return badgeLibrary;
}

#pragma mark DownloadManager Delegate

- (void)downloadManagerDidFinishDownloadOfBadges:(NSMutableArray *)badges andBadgeCategories:(NSMutableArray *)categories {
    self.badges = [self sortBadgesByCategoryWithBadges:badges];
    [self removeLoadingSubviews];
    self.badgeCategories = [self sortBadgeCategoriesByNumericalValue:categories];
    self.badgeLibrary = [self makeBadgeDictionaryWithBadges:self.badges sortedByWithCategories:self.badgeCategories];
    [self.collectionView reloadData];
}

- (void)downloadManagerFailedWithError:(NSError *)error {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"There was a problem downloading badge data." preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.downloadManager fetchBadgesAndCategories];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

#pragma mark DetailViewController Setup

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BadgeDetailViewController *detailViewController = [segue destinationViewController];
    BadgeCollectionViewCell *cell = sender;
    Badge *badge = [self getBadgeFromCell:cell];
    [detailViewController configureWithBadge:badge];
    
}

- (Badge *)getBadgeFromCell:(BadgeCollectionViewCell *)cell{
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:cell];
    Badge *badge = [[self.badgeLibrary objectForKey:@(cellIndexPath.section)] objectAtIndex:cellIndexPath.row];
    return badge;
    
}

#pragma mark Badge Categories View

- (void)categoriesButtonPressed:(UIBarButtonItem *)sender {
    /* Embed a categoryTableViewController in a navigationController and present it */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CategoryTableViewController *categoryTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"categoryTableViewController"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:categoryTableViewController];
    navController.navigationBar.translucent = NO;
    categoryTableViewController.categories = self.badgeCategories;
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark Helpers

- (UIColor *)uicolorForCategoryNumericalId:(NSNumber *)categoryNumber {
    UIColor *headerColor;
    switch ([categoryNumber intValue]) {
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
