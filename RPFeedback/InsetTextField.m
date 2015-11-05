//
//  InsetTextField.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/16/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "InsetTextField.h"

@implementation InsetTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10.0 , 0.0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10.0, 0.0);
}

@end
