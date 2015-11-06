//
//  ReviewViewController.h
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/15/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "RPBaseViewController.h"
#import "TPFloatRatingView.h"
#import "RPActivityIndicatorButton.h"
#import "InsetTextField.h"
#import "Feedback.h"
#import "SZTextView.h"

typedef NS_ENUM(NSUInteger, ReviewStep) {
    ReviewStepRate,
    ReviewStepAdditionalInformation
};

@interface FeedbackViewController : RPBaseViewController

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *poorLabel;
@property (nonatomic, strong) UILabel *averageLabel;
@property (nonatomic, strong) UILabel *bestLabel;
@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, strong) InsetTextField *nameTextField;
@property (nonatomic, strong) InsetTextField *emailTextField;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) RPActivityIndicatorButton *submitButton;
@property (nonatomic, strong) TPFloatRatingView *ratingView;
@property (nonatomic, assign) ReviewStep reviewStep;
@property (nonatomic, strong) Feedback *feedback;

- (void)setReviewStep:(ReviewStep)reviewStep animated:(BOOL)animated;

- (id)initWithReview:(Feedback *)review hideUserInformationFields:(BOOL)hideUserInformationFields;

@end
