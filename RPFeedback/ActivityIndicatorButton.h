//
//  ActivityIndicatorButton.h
//  Review Push For Business
//
//  Created by Michael Orcutt on 8/1/15.
//  Copyright (c) 2015 ReviewPush. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorButton : UIButton

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign, getter=isActivityIndicatorViewShowing) BOOL activityIndicatorViewShowing;

@end
