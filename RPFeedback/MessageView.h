//
//  MOMessageView.h
//  Stacks
//
//  Created by Michael Orcutt on 12/21/14.
//  Copyright (c) 2014 Michael Orcutt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonTapBlock)(void);

typedef NS_OPTIONS(NSInteger, MessageViewSubviewProperty) {
    MessageViewSubviewPropertyNone            = 0,
    MessageViewSubviewPropertyImageView       = 1 << 0,
    MessageViewSubviewPropertyTextLabel       = 1 << 1,
    MessageViewSubviewPropertyDetailTextLabel = 1 << 2,
    MessageViewSubviewPropertyButton          = 1 << 3,
};

typedef NS_ENUM(NSInteger, MessageViewStyle) {
    MessageViewStyleDefault      = 0,
    MessageViewStyleLightContent = 1
};

@interface MessageView : UIView

///------------------------------------------------
/// @name Style and Layout
///------------------------------------------------

/**
 * offset
 */
@property (nonatomic, assign) CGFloat verticalOffset;

/**
 * layout determines what views are initialized
 * for this view.
 */
@property (nonatomic, assign) MessageViewSubviewProperty subviewProperties;

/**
 * style determines the colors of the subviews
 */
@property (nonatomic, assign) MessageViewStyle style;

///------------------------------------------------
/// @name Subviews
///------------------------------------------------

/**
 * imageView is the image view that displays the
 * an icon for the message.
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 * textLabel is the text label displayed below
 * imageView.
 */
@property (nonatomic, strong) UILabel *textLabel;

/**
 * detailTextLabel is the text label displayed below
 * textLabel.
 */
@property (nonatomic, strong) UILabel *detailTextLabel;

/**
 * button is the button displayed below
 * detailTextLabel.
 */
@property (nonatomic, strong) UIButton *refreshButton;

///------------------------------------------------
/// @name Helpers
///------------------------------------------------

/**
 * buttonTapBlock is called when button is tapped.
 * 
 * @note: this will not return if subviews does
 * not contain MessageViewSubviewPropertyButton.
 */
@property (nonatomic, copy) ButtonTapBlock buttonTapBlock;

@end
