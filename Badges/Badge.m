//
//  Badge.m
//  Badges
//
//  Created by Joseph Maag on 2/19/15.
//  Copyright (c) 2015 Joseph Maag. All rights reserved.
//

#import "Badge.h"

@implementation Badge

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self assignValuesWithDictionary:data];
    }
    return self;
}

- (void)assignValuesWithDictionary:(NSDictionary *)dictionary {
    _iconSource = [dictionary objectForKey:@"icon_src"];
    _badgeDescription = [dictionary objectForKey:@"description"];
    _absoluteURL = [dictionary objectForKey:@"absolute_url"];
    _translatedSafeExtendedDesciption = [dictionary objectForKey:@"translated_safe_extended_description"];
    _translatedDescription = [dictionary objectForKey:@"translated_description"];
    _isOwned = [dictionary objectForKey:@"is_owned"];
    _category = [dictionary objectForKey:@"badge_category"];
    _points = [dictionary objectForKey:@"points"];
    _isRetired = [dictionary objectForKey:@"is_retired"];
    _safeExtendedDescription = [dictionary objectForKey:@"safe_extended_description"];
    _slug = [dictionary objectForKey:@"slug"];
    _name = [dictionary objectForKey:@"name"];
    NSDictionary *iconImageURLs = [dictionary objectForKey:@"icons"];
    _smallIconImageURL = [iconImageURLs objectForKey:@"compact"];
    _largeIconImageURL = [iconImageURLs objectForKey:@"large"];
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@\niconSource: %@\nbadge description: %@\nabsolute URL: %@\ntranslated description: %@\nis owned: %d\ncategory: %@\n", self.name, self.iconSource, self.badgeDescription, self.absoluteURL, self.translatedDescription, self.isOwned, self.category];
}

@end
