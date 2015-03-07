//
//  BadgeCategory.m
//  Badges
//
//  Created by Joseph Maag on 2/21/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import "BadgeCategory.h"

@implementation BadgeCategory

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self assignValuesWithDictionary:dict];
    }
    return self;
}

- (void)assignValuesWithDictionary:(NSDictionary *)dictionary {
    _numberId = [dictionary objectForKey:@"category"];
    _iconSource = [dictionary objectForKey:@"large_icon_src"];
    _categoryDescription = [dictionary objectForKey:@"description"];
    _chartIconSource = [dictionary objectForKey:@"chart_icon_src"];
    _name = [dictionary objectForKey:@"type_label"];
    
}
@end
