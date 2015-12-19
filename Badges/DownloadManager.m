//
//  DownloadManager.m
//  Badges
//
//  Created by Joseph Maag on 2/21/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import "DownloadManager.h"
#import "Badge.h"
#import "BadgeCategory.h"

static NSString * const badgeURLString = @"https://www.khanacademy.org/api/v1/badges";
static NSString * const categoryURLString = @"https://www.khanacademy.org/api/v1/badges/categories";

@interface DownloadManager ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) NSMutableArray *badgeCategories;

@end

@implementation DownloadManager

#pragma mark Setup

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

#pragma mark Fetching

- (void)fetchBadgesAndCategories {
    /* download badge data and make badge objects */
    [self fetchBadgesWithCompletionHandler:^(NSData *data) {
        NSArray *returnedBadgeData = (NSArray *)data;
        [self makeBadgesWithBadgeData:returnedBadgeData];
        /* download badge images and assign to badge objects */
        [self fetchBadgeImagesWithCompletionHandler:^() {
            /* download category data and make category objects */
            [self fetchCategoriesWithCompletionHandler:^(NSData *data) {
                NSArray *returnedCategoryData = (NSArray *)data;
                [self makeCategoriesWithCategoryData:returnedCategoryData];
                [self fetchCategoryImagesWithCompletionHandler:^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    /* when categories are done, send objects to viewController */
                    [self.delegate downloadManagerDidFinishDownloadOfBadges:self.badges andBadgeCategories:self.badgeCategories];
                }];
            }];
        }];
    }];
}

- (void)fetchBadgesWithCompletionHandler:(void (^)(NSData *))completionHandler {
    /* Gets badge data */
    self.badges = [NSMutableArray new];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:badgeURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self handleError:error];
        }else{
            NSError *error;
            NSData *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(jsonData);
            }];
        }
    }];
    [task resume];
    
}

- (void)fetchCategoriesWithCompletionHandler:(void (^)(NSData *))completionHandler {
    /* Gets category data */
    self.badgeCategories = [NSMutableArray new];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:categoryURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self handleError:error];
        }else{
            NSError *error1;
            NSData *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(jsonData);
            }];
        }
    }];
    [task resume];
}

- (void)fetchBadgeImagesWithCompletionHandler:(void (^)())completionHandler {
    /* Gets regular size badge images */
    if (self.badges) {
        __block NSUInteger numberOfBadges = [self.badges count];
        for (Badge *badge in self.badges) {
            NSString *imageURL = badge.smallIconImageURL;
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [self handleError:error];
                }else{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UIImage *image = [UIImage imageWithData:data];
                        badge.smallIconImage = image;
                        numberOfBadges--;
                        if (numberOfBadges == 0) {
                            [self fetchLargeBadgeImagesWithCompletionHandler:completionHandler];
                        }
                    }];
                }
            }];
            [task resume];
        }
    }
}

- (void)fetchLargeBadgeImagesWithCompletionHandler:(void (^)())completionHandler {
    /* Gets large size badge images */
    if (self.badges) {
        __block NSUInteger numberOfBadges = [self.badges count];
        for (Badge *badge in self.badges) {
            NSString *imageURL = badge.largeIconImageURL;
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [self handleError:error];
                }else{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UIImage *image = [UIImage imageWithData:data];
                        badge.largeIconImage = image;
                        numberOfBadges--;
                        if (numberOfBadges == 0) {
                            completionHandler();
                        }
                    }];
                }
            }];
            [task resume];
        }
    }
}

- (void)fetchCategoryImagesWithCompletionHandler:(void (^)())completionHandler {
    /* Gets large size category images */
    if (self.badgeCategories) {
        __block NSUInteger numberOfCategories = [self.badgeCategories count];
        for (BadgeCategory *category in self.badgeCategories) {
            NSString *imageURL = category.iconSource;
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [self handleError:error];
                }else{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UIImage *image = [UIImage imageWithData:data];
                        category.largeIconImage = image;
                        numberOfCategories--;
                        if (numberOfCategories == 0) {
                            completionHandler();
                        }
                    }];
                }
            }];
            [task resume];
        }
    }
}

#pragma mark Data Translators

- (void)makeBadgesWithBadgeData:(NSArray *)badgeDataArray {
    for (NSDictionary *badgeDict in badgeDataArray) {
        Badge *badge = [[Badge alloc]initWithDictionary:badgeDict];
        [self.badges addObject:badge];
        
    }
}

- (void)makeCategoriesWithCategoryData:(NSArray *)categoryDataArray {
    for (NSDictionary *categoryDict in categoryDataArray) {
        BadgeCategory *category = [[BadgeCategory alloc]initWithDictionary:categoryDict];
        [self.badgeCategories addObject:category];
    }
}

#pragma mark Error Handling

- (void)handleError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    [self.delegate downloadManagerFailedWithError:error];
}




@end
