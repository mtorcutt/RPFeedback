//
//  Review.h
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "JSONModel.h"

@interface RPReviewSite : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;

@end
