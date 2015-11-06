//
//  Location.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "RPLocation.h"
#import <UIKit/UIKit.h>

@implementation RPLocation

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    NSDictionary *dictionary = @{ @"id"                   : @"identifier",
                                  @"attributes.name"      : @"name",
                                  @"attributes.address_1" : @"lineOne",
                                  @"attributes.address_2" : @"lineTwo",
                                  @"attributes.city"      : @"city",
                                  @"attributes.state"     : @"state",
                                  @"attributes.zip"       : @"zip" };
                                  
    return [[JSONKeyMapper alloc] initWithDictionary:dictionary];
}

- (NSAttributedString *)addressAtrributedString {
    
    NSString *lineOne   = self.lineOne;
    NSString *lineTwo   = self.lineTwo;
    NSString *lineThree = [NSString stringWithFormat:@"%@, %@ %@", self.city, self.state, self.zip];
    
    NSMutableString *mutableString = [NSMutableString new];
    
    if(lineOne.length > 0) {
        [mutableString appendString:lineOne];
    }

    if(lineTwo.length > 0) {
        [mutableString appendString:@"\n"];
        [mutableString appendString:lineTwo];
    }

    if(lineThree.length > 0) {
        [mutableString appendString:@"\n"];
        [mutableString appendString:lineThree];
    }
    
    NSDictionary *attributes
    = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
         NSFontAttributeName            : [UIFont systemFontOfSize:15.0] };

    NSDictionary *secondaryAttributes
    = @{ NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:.80],
         NSFontAttributeName            : [UIFont systemFontOfSize:13.0] };

    NSMutableAttributedString *string
    = [[NSMutableAttributedString alloc] initWithString:mutableString attributes:secondaryAttributes];
    [string setAttributes:attributes range:NSMakeRange(0, lineOne.length)];
    
    return string;
    
}

@end
