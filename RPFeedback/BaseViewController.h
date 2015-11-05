//
//  BaseViewController.h
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)displayActivityIndicatorViewAnimated:(BOOL)animated;
- (void)removeActivityIndicatorViewAnimated:(BOOL)animated;
- (void)removeMessageViewAnimated:(BOOL)animated;
- (void)displayMessageViewAnimated:(BOOL)animated
                             image:(UIImage *)image
                             title:(NSString *)title
                        detailText:(NSString *)detailText
                       buttonTitle:(NSString *)buttonTitle
                      buttonTapped:(void(^)(void))buttonTappedBlock;

- (void)handleDismissButton:(id)sender;

@property (nonatomic, assign) BOOL insertDismissButton;
@property (nonatomic, strong) NSString *APIKey;
@property (nonatomic, strong) NSString *APISecret;

@end
