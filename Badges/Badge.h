//
//  Badge.h
//  Badges
//
//  Created by Joseph Maag on 2/19/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Badge : NSObject

@property (nonatomic, strong, readonly) NSString *badgeDescription;
@property (nonatomic, strong, readonly) NSString *iconSource;
@property (nonatomic, strong, readonly) NSString *absoluteURL;
@property (nonatomic, strong, readonly) NSString *translatedSafeExtendedDesciption;
@property (nonatomic, strong, readonly) NSString *translatedDescription;
@property (nonatomic, readonly) BOOL isOwned;
@property (nonatomic, strong, readonly) NSNumber *category;
@property (nonatomic, strong, readonly) NSNumber *points;
@property (nonatomic, readonly) BOOL isRetired;
@property (nonatomic, strong, readonly) NSString *safeExtendedDescription;
@property (nonatomic, strong, readonly) NSString *slug;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *smallIconImageURL;
@property (nonatomic, strong, readonly) NSString *largeIconImageURL;
@property (nonatomic, strong,) UIImage *largeIconImage;
@property (nonatomic, strong,) UIImage *smallIconImage;

- (instancetype)initWithDictionary:(NSDictionary *)data;

@end
