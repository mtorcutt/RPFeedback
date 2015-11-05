//
//  ReviewViewController.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "RPFeedbackViewController.h"

#import "LocationManagerViewController.h"
#import "PushTransition.h"

@interface RPFeedbackViewController () <UINavigationControllerDelegate>

@end

@implementation RPFeedbackViewController

#pragma mark - Initialization Assertion

- (id)init {
    
    NSAssert(nil, @"Please use initWithFeedback:(Feedback *)feedback APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret to intialize this view controller.");
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    NSAssert(nil, @"Please use initWithFeedback:(Feedback *)feedback APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret to intialize this view controller.");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSAssert(nil, @"Please use initWithFeedback:(Feedback *)feedback APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret to intialize this view controller.");
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    NSAssert(nil, @"Please use initWithFeedback:(Feedback *)feedback APIKey:(NSString *)APIKey APISecret:(NSString *)APISecret to intialize this view controller.");
    
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
}

#pragma mark - Initialization

- (id)initWithFeedback:(Feedback *)feedback
                APIKey:(NSString *)APIKey
             APISecret:(NSString *)APISecret {
    
    LocationManagerViewController *viewController = [LocationManagerViewController new];
    viewController.feedback                       = feedback;
    viewController.APISecret                      = APISecret;
    viewController.APIKey                         = APISecret;
    
    self = [super initWithRootViewController:viewController];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the delegate for
    // UINavigationControllerDelegate
    // methods to be handled
    self.delegate = self;
    
    // Get rid of the navigation bar,
    // but we still want it for
    // navigation bar button items
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    // If we can, lets use the blur effect.
    // Note: this only works in iOS8+
    if([UIBlurEffect class] && [UIVisualEffectView class]) {
        self.view.backgroundColor = [UIColor clearColor];

        UIBlurEffect *blurEffect          = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectiveView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        effectiveView.frame = self.view.bounds;
        
        [self.view insertSubview:effectiveView atIndex:0];
    } else {
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.90];
    }
    
    // Update status bar.
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Transition Delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromViewController
                                                toViewController:(UIViewController *)toViewController {
    PushTransition *transition = [PushTransition new];
    transition.operation         = operation;
    
    return transition;
}

@end
