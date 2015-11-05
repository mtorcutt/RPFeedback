//
//  BaseViewController.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageView.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MessageView *messageView;

@end

@implementation BaseViewController

#pragma mark - View lifecycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutActivityIndicatorView];
    [self layoutMessageView];
}

- (void)layoutActivityIndicatorView {
    if(self.activityIndicator) {
        self.activityIndicator.frame = self.view.bounds;
    }
}

- (void)layoutMessageView
{
    if(self.messageView == nil) {
        return;
    }
    
    self.messageView.frame = self.view.bounds;
}

#pragma mark - Activity Indicator

- (void)displayActivityIndicatorViewAnimated:(BOOL)animated {
    
    if(self.activityIndicator == nil) {
        self.activityIndicator
        = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        self.activityIndicator.color = [UIColor colorWithWhite:1.0 alpha:1.0];
        
        if(animated == YES) {
            self.activityIndicator.alpha = 0.0;
        }
        
        [self layoutActivityIndicatorView];
        
        [self.view addSubview:self.activityIndicator];
        [self.view bringSubviewToFront:self.activityIndicator];
    }
    
    [self.activityIndicator startAnimating];
    
    if(animated == YES) {
        [UIView animateWithDuration:.35 animations:^{
            self.activityIndicator.alpha = 1.0;
        }];
    }
}

- (void)removeActivityIndicatorViewAnimated:(BOOL)animated {
    
    if(animated) {
        
        [UIView animateWithDuration:.35 animations:^{
            self.activityIndicator.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.activityIndicator removeFromSuperview];
            self.activityIndicator = nil;
        }];
        
    } else {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
    
}

#pragma mark - Message View

- (void)displayMessageViewAnimated:(BOOL)animated
                             image:(UIImage *)image
                             title:(NSString *)title
                        detailText:(NSString *)detailText
                       buttonTitle:(NSString *)buttonTitle
                      buttonTapped:(void(^)(void))buttonTappedBlock
{
    if(self.messageView == nil) {
        self.messageView = [MessageView new];
        
        if(animated) {
            self.messageView.alpha = 0.0;
        }
        
        [self layoutMessageView];
        
        [self.view addSubview:self.messageView];
        [self.view bringSubviewToFront:self.messageView];
    }
    
    [self.messageView.imageView      setImage:image];
    [self.messageView.textLabel       setText:title];
    [self.messageView.detailTextLabel setText:detailText];
    [self.messageView.refreshButton setTitle:buttonTitle
                                    forState:UIControlStateNormal];
    
    [self layoutMessageView];
    [self.messageView layoutSubviews];
    
    self.messageView.buttonTapBlock = ^{
        if(buttonTappedBlock) {
            buttonTappedBlock();
        }
    };
    
    if(animated) {
        [UIView animateWithDuration:.35 animations:^{
            self.messageView.alpha = 1.0;
        }];
    }
}

- (void)removeMessageViewAnimated:(BOOL)animated
{
    if(animated) {
        [UIView animateWithDuration:.35 animations:^{
            self.messageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.messageView = nil;
        }];
    } else {
        self.messageView.alpha = 0.0;
        self.messageView = nil;
    }
}

#pragma mark - Dismiss Button

- (void)setInsertDismissButton:(BOOL)insertDismissButton {
    _insertDismissButton = insertDismissButton;
    
    if(_insertDismissButton == YES) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setImage:[UIImage imageNamed:@"x~22x22"] forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button addTarget:self
                   action:@selector(handleDismissButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [button sizeToFit];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
     
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
    }
}

- (void)handleDismissButton:(id)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.navigationController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished == NO) {
            return;
        }

        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
