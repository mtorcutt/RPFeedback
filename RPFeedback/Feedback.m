
//  Review.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/25/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "Feedback.h"

@implementation Feedback

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *dictionary = @{ @"review_site_links" : @"reviewSiteLinks",
                                  @"id"                : @"identifier",
                                  @"attributes.rating" : @"rating" };

    return [[JSONKeyMapper alloc] initWithDictionary:dictionary];
}

@end
