//
//  Review.h
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/25/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "JSONModel.h"

#import "RPLocation.h"

@interface RPFeedback : JSONModel

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *feedback;
@property (nonatomic, assign) NSInteger ratingValue;
@property (nonatomic, strong) RPLocation *location;

@end
