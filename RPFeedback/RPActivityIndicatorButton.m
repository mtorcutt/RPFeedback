//
//  ActivityIndicatorButton.m
//  Review Push For Business
//
//  Created by Michael Orcutt on 8/1/15.
//  Copyright (c) 2015 ReviewPush. All rights reserved.
//

#import "RPActivityIndicatorButton.h"

@implementation RPActivityIndicatorButton

- (void)setActivityIndicatorViewShowing:(BOOL)activityIndicatorViewShowing {

    if(_activityIndicatorViewShowing == activityIndicatorViewShowing) {
        return;
    }
    
    _activityIndicatorViewShowing = activityIndicatorViewShowing;
    
    if(_activityIndicatorViewShowing == YES) {
        
        if(_activityIndicatorView == nil) {
            
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
            [self addSubview:self.activityIndicatorView];
            
        }
        
        [self.activityIndicatorView startAnimating];
        
        [self layoutActivityIndicatorView];
        
    } else {
        
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
        
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutActivityIndicatorView];
}

- (void)layoutActivityIndicatorView {
    
    CGSize boundsSize = self.bounds.size;
    
    CGRect activityIndicatorViewFrame = CGRectZero;
    activityIndicatorViewFrame.size   = CGSizeMake(boundsSize.height, boundsSize.height);
    activityIndicatorViewFrame.origin = CGPointMake(boundsSize.width - activityIndicatorViewFrame.size.width, 0.0);
    
    self.activityIndicatorView.frame = activityIndicatorViewFrame;
    
}

@end
