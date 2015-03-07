//
//  BadgeCategory.h
//  Badges
//
//  Created by Joseph Maag on 2/21/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeCategory : NSObject

@property (nonatomic, strong, readonly) NSNumber *numberId;
@property (nonatomic, strong, readonly) NSString *iconSource;
@property (nonatomic, strong, readonly) NSString *categoryDescription;
@property (nonatomic, strong, readonly) NSString *chartIconSource;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) UIImage *largeIconImage;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
