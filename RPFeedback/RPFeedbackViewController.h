//
//  ReviewViewController.h
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPFeedback.h"

@interface RPFeedbackViewController : UINavigationController

- (id)initWithFeedback:(RPFeedback *)feedback
                APIKey:(NSString *)APIKey
             APISecret:(NSString *)APISecret;

@end
