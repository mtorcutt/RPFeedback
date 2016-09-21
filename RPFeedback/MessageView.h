//
//  MOMessageView.h
//  Stacks
//
//  Created by Michael Orcutt on 12/21/14.
//  Copyright (c) 2014 Michael Orcutt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonTapBlock)(void);

@interface MessageView : UIView

///------------------------------------------------
/// @name Style and Layout
///------------------------------------------------

/**
 * offset
 */
@property (nonatomic, assign) CGFloat verticalOffset;

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
