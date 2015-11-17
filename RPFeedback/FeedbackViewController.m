//
//  ReviewViewController.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/15/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "FeedbackViewController.h"

#import "RPFeedbackClient.h"
#import "PositiveReinforcementViewController.h"

CGFloat const ContentWidth    = 300.0;
CGFloat const TextViewHeight  = 100.0;
CGFloat const TextFieldHeight = 44.0;
CGFloat const Padding         = 15.0;
CGFloat const StatusBarHeight = 15.0;

@interface FeedbackViewController () <TPFloatRatingViewDelegate, UITextViewDelegate>

@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, assign) BOOL hideUserInformationFields;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) UIView *topViewsContainer;

@end

@implementation FeedbackViewController

#pragma mark - Initialization

- (id)initWithReview:(Feedback *)review hideUserInformationFields:(BOOL)hideUserInformationFields {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.feedback                  = review;
        self.hideUserInformationFields = hideUserInformationFields;
        self.statusBarStyle            = [[UIApplication sharedApplication] statusBarStyle];
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.view = [UIScrollView new];
    
    [(UIScrollView *)self.view setShowsVerticalScrollIndicator:NO];

    self.insertDismissButton = YES;
    
    // Create all subviews (minus user information fields – these
    // will be created in the hideUserInformationFields boolean
    // setter
    self.topViewsContainer = [UIView new];
    
    [self.view addSubview:self.topViewsContainer];
    
    self.textLabel               = [UILabel new];
    self.textLabel.font          = [UIFont systemFontOfSize:22.0];
    self.textLabel.text          = [NSString stringWithFormat:@"Please rate your experience at %@ below.", self.feedback.location.name];;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textColor     = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.transform     = CGAffineTransformMakeScale(.90, .90);

    [self.view addSubview:self.textLabel];
    
    self.ratingView                    = [TPFloatRatingView new];
    
//    _starRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    _starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    _starRating.maxRating = 5.0;
//    _starRating.delegate = self;
//    _starRating.horizontalMargin = 15.0;
//    _starRating.editable=YES;
//    _starRating.rating= 2.5;
//    _starRating.displayMode=EDStarRatingDisplayHalf;
//    [_starRating  setNeedsDisplay];
//    _starRating.tintColor = self.colors[0];

    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"star"];
    self.ratingView.fullSelectedImage  = [UIImage imageNamed:@"star-full"];
    self.ratingView.delegate           = self;
    self.ratingView.editable           = YES;
//    self.ratingView.transform          = CGAffineTransformMakeScale(.75, .75);

    [self.view addSubview:self.ratingView];
    
    self.poorLabel               = [UILabel new];
    self.poorLabel.font          = [UIFont systemFontOfSize:13.0];
    self.poorLabel.text          = @"Poor";
    self.poorLabel.textColor     = [UIColor colorWithWhite:1.0 alpha:.75];
    
    [self.view addSubview:self.poorLabel];

    self.averageLabel               = [UILabel new];
    self.averageLabel.font          = [UIFont systemFontOfSize:13.0];
    self.averageLabel.text          = @"Average";
    self.averageLabel.textColor     = [UIColor colorWithWhite:1.0 alpha:.75];
    
    [self.view addSubview:self.averageLabel];

    self.bestLabel               = [UILabel new];
    self.bestLabel.font          = [UIFont systemFontOfSize:13.0];
    self.bestLabel.text          = @"Best";
    self.bestLabel.textColor     = [UIColor colorWithWhite:1.0 alpha:.75];
    
    [self.view addSubview:self.bestLabel];
    
    self.textView = SZTextView.new;
    
    self.textView.backgroundColor    = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 4.0;
    self.textView.alpha              = 0.0;
    self.textView.font               = [UIFont systemFontOfSize:16.0];
    self.textView.textContainerInset = UIEdgeInsetsMake(10.0, 6.0, 10.0, 10.0);
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.delegate           = self;
    
    [self.view addSubview:self.textView];
    
    self.submitButton = [RPActivityIndicatorButton buttonWithType:UIButtonTypeSystem];
    
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]];
    [self.submitButton.layer setBorderWidth:2.0];
    [self.submitButton setContentEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 12.0, 10.0)];
    [self.submitButton setTitle:@"Submit Review" forState:UIControlStateNormal];
    
    UIColor *color = [UIColor colorWithRed:27.0/255.0 green:190.0/255.0 blue:134.0/255.0 alpha:1.0];
    
    [self.submitButton.layer setBorderColor:color.CGColor];
    [self.submitButton setBackgroundColor:color];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setAlpha:0.0];
    [self.submitButton addTarget:self
                          action:@selector(handleSubmit:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.submitButton];
    
    // Set hideUserInformationFields
    // again in case
    // the view controller
    // was initialized without
    // the correct initializer
    self.hideUserInformationFields = _hideUserInformationFields;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [(UIScrollView *)self.view setContentSize:self.view.bounds.size];
    
    // Layout dismiss button
    CGRect dismissButtonFrame = CGRectZero;
    dismissButtonFrame.size   = [self.dismissButton sizeThatFits:self.view.bounds.size];
    dismissButtonFrame.origin = CGPointMake(0.0, StatusBarHeight);
    
    self.dismissButton.frame = dismissButtonFrame;
    
    // Let -layoutRatingView handle
    // laying out the rest of the views
    [self layoutRatingView];
}

- (void)layoutRatingView {
    
    // Layout setup
    CGSize viewBoundsSize = self.view.bounds.size;
    
    CGSize maxLabelSize = CGSizeMake(viewBoundsSize.width - (Padding * 2.0), CGFLOAT_MAX);
    
    // textLabel frame
    CGRect textLabelFrame = CGRectZero;
    textLabelFrame.size
    = [self.textLabel.text boundingRectWithSize:maxLabelSize
                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{ NSFontAttributeName : self.textLabel.font }
                                        context:nil].size;
    textLabelFrame.origin.x
    = (viewBoundsSize.width - textLabelFrame.size.width)/2.0;
    
    UIImage *starImage = [UIImage imageNamed:@"star-full"];
    
    // ratingView frame
    CGRect ratingViewFrame   = CGRectZero;
    ratingViewFrame.size     = CGSizeMake((ContentWidth - Padding * 2.0), starImage.size.height);
    ratingViewFrame.origin.x = (viewBoundsSize.width - ratingViewFrame.size.width)/2.0;

    // Text view and text field
    // frame setup
    CGRect textViewFrame = CGRectZero;
    textViewFrame.size   = CGSizeMake(ContentWidth, TextViewHeight);
    
    CGFloat textFieldWidth = (ContentWidth - Padding)/2.0;
    
    CGRect nameTextFieldFrame = CGRectZero;
    nameTextFieldFrame.size   = CGSizeMake(textFieldWidth, TextFieldHeight);
    
    CGRect emailTextFieldFrame = CGRectZero;
    emailTextFieldFrame.size   = CGSizeMake(textFieldWidth, TextFieldHeight);

    // Calculate initial view (textLabel) frame
    // to calculate where the origin begins
    if(self.reviewStep == ReviewStepRate) {
        textLabelFrame.origin.y
        = (viewBoundsSize.height
           - textLabelFrame.size.height
           - Padding
           - starImage.size.height)/2.0;
    } else if(self.hideUserInformationFields) {
        textLabelFrame.origin.y
        = (viewBoundsSize.height
           - textLabelFrame.size.height
           - Padding
           - starImage.size.height
           - textViewFrame.size.height)/2.0;
    } else {
        textLabelFrame.origin.y
        = (viewBoundsSize.height
           - textLabelFrame.size.height
           - Padding * 3.0
           - starImage.size.height
           - emailTextFieldFrame.size.height
           - nameTextFieldFrame.size.height
           - textViewFrame.size.height)/2.0;
    }
    
    ratingViewFrame.origin.y = CGRectGetMaxY(textLabelFrame) + Padding;
    
    // Get star to layout star
    // description labels
    CGSize starSize = starImage.size;

    CGRect poorLabelFrame   = CGRectZero;
    poorLabelFrame.origin.y = (CGRectGetMaxY(ratingViewFrame) + 5.0);
    poorLabelFrame.size     = [self.poorLabel.text sizeWithAttributes:@{ NSFontAttributeName : self.poorLabel.font }];
    poorLabelFrame.origin.x = CGRectGetMinX(ratingViewFrame) + ((starSize.width - poorLabelFrame.size.width)/2.0);
    
    self.poorLabel.frame = poorLabelFrame;

    CGRect averageLabelFrame   = CGRectZero;
    averageLabelFrame.origin.y = (CGRectGetMaxY(ratingViewFrame) + 5.0);
    averageLabelFrame.size     = [self.averageLabel.text sizeWithAttributes:@{ NSFontAttributeName : self.averageLabel.font }];
    averageLabelFrame.origin.x = CGRectGetMidX(ratingViewFrame) - averageLabelFrame.size.width/2.0;
    
    self.averageLabel.frame = averageLabelFrame;

    CGRect bestLabelFrame   = CGRectZero;
    bestLabelFrame.origin.y = (CGRectGetMaxY(ratingViewFrame) + 5.0);
    bestLabelFrame.size     = [self.bestLabel.text sizeWithAttributes:@{ NSFontAttributeName : self.bestLabel.font }];
    bestLabelFrame.origin.x = CGRectGetMaxX(ratingViewFrame) - bestLabelFrame.size.width/2.0 - starSize.width/2.0;
    
    self.bestLabel.frame = bestLabelFrame;
    
    // Set textView origin
    // under textViewFrame
    textViewFrame.origin
    = CGPointMake((viewBoundsSize.width - textViewFrame.size.width)/2.0,
                  CGRectGetMaxY(poorLabelFrame) + 15.0);
    
    nameTextFieldFrame.origin.x = CGRectGetMinX(textViewFrame);
    nameTextFieldFrame.origin.y = CGRectGetMaxY(textViewFrame) + 15.0;
    
    self.nameTextField.frame = nameTextFieldFrame;
    
    emailTextFieldFrame.origin.x = CGRectGetMaxX(textViewFrame) - emailTextFieldFrame.size.width;
    emailTextFieldFrame.origin.y = CGRectGetMaxY(textViewFrame) + 15.0;
    
    self.emailTextField.frame = emailTextFieldFrame;

    self.textView.frame   = textViewFrame;
    self.ratingView.frame = ratingViewFrame;
    self.textLabel.frame  = textLabelFrame;
    
    CGRect submitButtonFrame = CGRectZero;
    submitButtonFrame.size   = [self.submitButton sizeThatFits:viewBoundsSize];
    submitButtonFrame.size.width = ContentWidth;
    submitButtonFrame.origin = CGPointMake((viewBoundsSize.width - submitButtonFrame.size.width)/2.0, CGRectGetMaxY(emailTextFieldFrame) + 15.0);
    
    self.submitButton.frame = submitButtonFrame;
    self.submitButton.layer.cornerRadius = submitButtonFrame.size.height/2.0;
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    self.keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [(UIScrollView *)self.view setContentInset:UIEdgeInsetsMake(0.0, 0.0, self.keyboardSize.height, 0.0)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.keyboardSize = CGSizeZero;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [(UIScrollView *)self.view setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
}

#pragma mark - Review Step

- (void)setReviewStep:(ReviewStep)reviewStep {
    [self setReviewStep:reviewStep animated:NO];
}

- (void)setReviewStep:(ReviewStep)reviewStep animated:(BOOL)animated {
    _reviewStep = reviewStep;

    [self layoutRatingView];
}

#pragma mark - Rating view delegate and related methods

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating {
    self.feedback.ratingValue = rating;
    
    [self helpTheViewsForRatingView:ratingView rating:rating];    
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating {
    
    self.feedback.ratingValue = rating;

    [self helpTheViewsForRatingView:ratingView rating:rating];
    
    CGPoint center = self.textLabel.center;
    center.x       = self.view.center.x;
    
    CGFloat scaleFactor = 1.0;
    CGFloat x_delta = self.textLabel.frame.size.width * (1-scaleFactor);
    CGFloat y_delta = self.textLabel.frame.size.height * (1-scaleFactor);

    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0.0);
    transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);
    transform = CGAffineTransformTranslate(transform, -x_delta, -y_delta);

    [UIView animateWithDuration:.35 animations:^{
        [self setReviewStep:ReviewStepAdditionalInformation animated:YES];
        
        self.textLabel.transform = CGAffineTransformIdentity;
        self.ratingView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(finished == NO) {
            return;
        }
        
        [UIView animateWithDuration:.35 animations:^{
            self.nameTextField.alpha = 1.0;
            self.emailTextField.alpha = 1.0;
            self.textView.alpha = 1.0;
            self.submitButton.alpha = 1.0;
        }];
    }];
}

- (void)helpTheViewsForRatingView:(TPFloatRatingView *)ratingView rating:(NSInteger)rating {
    NSString *placeHolderText = nil;
    
    if(rating <= 1.0) {
        ratingView.rating = 1.0;
        placeHolderText
        = @"Please tell us more. For example, what made this a negative experience?";
    } else if(rating == 2.0) {
        placeHolderText
        = @"Please tell us more. For example, what made this a negative experience?";
    } else if(rating == 3.0) {
        placeHolderText
        = @"Please tell us more. For example, how can we improve the experience?";
    } else if(rating == 4.0) {
        placeHolderText
        = @"Please tell us more. For example, what did you like best or what would you recommend to a friend?";
    } else {
        placeHolderText
        = @"Please tell us more. For example, what did you like best or what would you recommend to a friend?";
    }
    
    self.textView.placeholder = placeHolderText;
}

#pragma mark - Button methods

- (void)handleSubmit:(id)sender {
    
    self.submitButton.userInteractionEnabled = NO;
    self.submitButton.activityIndicatorViewShowing = YES;
    
    RPFeedbackClient *feedbackClient
    = [RPFeedbackClient sharedClientWithKey:self.APIKey secret:self.APISecret];
    
    [feedbackClient POSTFeedback:self.feedback
                      completion:^(BOOL success,
                                   Feedback *feedBack,
                                   NSDictionary *reviewSiteLinks,
                                   NSString *errorString) {

        if(success && [reviewSiteLinks isKindOfClass:[NSDictionary class]]) {
            
            PositiveReinforcementViewController *viewController
            = [PositiveReinforcementViewController new];
            viewController.reviewSites = reviewSiteLinks;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if(success) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Thank you for submitting your review." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            [self handleDismissButton:nil];
            
        } else {
            
            NSString *alertTitle       = @"Feedback";
            NSString *message          = @"There was an issue submitting. Please try again.";
            NSString *cancelButtonText = @"OK";
            
            if([UIAlertController class]) {
                
                UIAlertController *alertController
                = [UIAlertController alertControllerWithTitle:alertTitle
                                                      message:message
                                               preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *dismissButton
                = [UIAlertAction actionWithTitle:cancelButtonText
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                
                [alertController addAction:dismissButton];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:cancelButtonText
                                                          otherButtonTitles:nil];
                [alertView show];

            }
            
        }

        self.submitButton.activityIndicatorViewShowing = NO;
        self.submitButton.userInteractionEnabled       = YES;

    }];
}

#pragma mark - Setters

- (void)setHideUserInformationFields:(BOOL)hideUserInformationFields {

    if(hideUserInformationFields == YES
       && self.feedback.emailAddress.length > 0
       && self.feedback.fullName.length > 0) {
        _hideUserInformationFields = hideUserInformationFields;
        return;
    } else {
        _hideUserInformationFields = hideUserInformationFields;
        
        if(self.nameTextField == nil) {
            self.nameTextField = InsetTextField.new;
            
            self.nameTextField.backgroundColor    = [UIColor whiteColor];
            self.nameTextField.layer.cornerRadius = 4.0;
            self.nameTextField.placeholder        = @"Full Name";
            self.nameTextField.alpha              = 0.0;
            self.nameTextField.font               = [UIFont systemFontOfSize:16.0];
            self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;

            [self.nameTextField addTarget:self
                                   action:@selector(handleTextFieldChange:)
                         forControlEvents:UIControlEventEditingChanged];

            [self.view addSubview:self.nameTextField];
        }
        
        if(self.emailTextField == nil) {
            self.emailTextField = InsetTextField.new;
            
            self.emailTextField.backgroundColor    = [UIColor whiteColor];
            self.emailTextField.layer.cornerRadius = 4.0;
            self.emailTextField.placeholder        = @"Email Address";
            self.emailTextField.alpha              = 0.0;
            self.emailTextField.font               = [UIFont systemFontOfSize:16.0];
            self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            
            [self.emailTextField addTarget:self
                                    action:@selector(handleTextFieldChange:)
                          forControlEvents:UIControlEventEditingChanged];
            
            [self.view addSubview:self.emailTextField];
        }
    }
    
}

#pragma mark - Text field

- (void)handleTextFieldChange:(UITextField *)textField {
    if([textField isEqual:self.emailTextField]) {
        self.feedback.emailAddress = textField.text;
    } else { // full name
        self.feedback.fullName = textField.text;
    }
}

#pragma mark - Text view delegate

- (void)textViewDidChange:(UITextView *)textView {
    self.feedback.feedback = textView.text;
}

@end
