//
//  DownloadManager.h
//  Badges
//
//  Created by Joseph Maag on 2/21/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadManagerDelegate <NSObject>

- (void)downloadManagerDidFinishDownloadOfBadges:(NSMutableArray *)badges andBadgeCategories:(NSMutableArray *)categories;
- (void)downloadManagerFailedWithError:(NSError *)error;

@end


@interface DownloadManager : NSObject

@property (weak, nonatomic) id<DownloadManagerDelegate> delegate;

- (void)fetchBadgesAndCategories;

@end
