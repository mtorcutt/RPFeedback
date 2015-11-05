//
//  MOMessageView.m
//  Stacks
//
//  Created by Michael Orcutt on 12/21/14.
//  Copyright (c) 2014 Michael Orcutt. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        self.alpha                  = 1.0;
        self.userInteractionEnabled = YES;
        self.backgroundColor        = [UIColor clearColor];
        
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super subviews];
    
    // Layout setup
    CGSize boundsSize = self.bounds.size;
    
    CGSize maxLabelSize = CGSizeMake((boundsSize.width - (15.0 * 2.0)), CGFLOAT_MAX);
    
    // imageView frame setup
    CGRect imageViewFrame = CGRectZero;
    
    if(self.imageView != nil) {
        imageViewFrame.size     = self.imageView.image.size;
        imageViewFrame.origin.x = floorf((boundsSize.width - imageViewFrame.size.width)/2.0);
    }

    // textLabel frame setup
    CGRect textLabelFrame = CGRectZero;
    
    if(self.textLabel != nil) {
        textLabelFrame.size = [self.textLabel.text boundingRectWithSize:maxLabelSize
                                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                                             attributes:@{ NSFontAttributeName : self.textLabel.font }
                                                                context:nil].size;
        textLabelFrame.origin.x = floorf((boundsSize.width - textLabelFrame.size.width)/2.0);
    }
    
    // detailTextLabel frame setup
    CGRect detailTextLabelFrame = CGRectZero;
    
    if(self.detailTextLabel != nil) {
        detailTextLabelFrame.size = [self.detailTextLabel.text boundingRectWithSize:maxLabelSize
                                                                            options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                                                         attributes:@{ NSFontAttributeName : self.detailTextLabel.font }
                                                                            context:nil].size;
        detailTextLabelFrame.origin.x = floorf((boundsSize.width - detailTextLabelFrame.size.width)/2.0);
    }
    
    // button frame setup
    CGRect buttonFrame = CGRectZero;
    
    if(self.refreshButton != nil) {
        [self.refreshButton sizeToFit];
        
        buttonFrame.size     = self.refreshButton.bounds.size;
        buttonFrame.origin.x = floorf((boundsSize.width - buttonFrame.size.width)/2.0);
    }
    
    // Calculate y offsets
    CGFloat spacing = 0.0;
    
    if(self.imageView) {
        spacing += 15.0;
    }
    
    if(self.refreshButton) {
        spacing += 15.0;
    }
    
    CGFloat yOffset
    = floorf((boundsSize.height
              - imageViewFrame.size.height
              - textLabelFrame.size.height
              - detailTextLabelFrame.size.height
              - spacing - self.verticalOffset)
             / 2.0);
    
    imageViewFrame.origin.y = yOffset;
    
    yOffset += imageViewFrame.size.height;
    
    if(self.imageView != nil) {
        yOffset += 15.0;
    }
    
    textLabelFrame.origin.y = yOffset;
    
    yOffset += textLabelFrame.size.height;
    
    detailTextLabelFrame.origin.y = yOffset;
    
    yOffset += detailTextLabelFrame.size.height;
    
    if(self.refreshButton != nil) {
        yOffset += 15.0;
    }

    buttonFrame.origin.y = yOffset;
    
    // Set frames
    self.imageView.frame       = imageViewFrame;
    self.textLabel.frame       = textLabelFrame;
    self.detailTextLabel.frame = detailTextLabelFrame;
    self.refreshButton.frame   = buttonFrame;
}

#pragma mark - Helpers

- (void)setSubviewProperties:(MessageViewSubviewProperty)subviewProperties
{
    if(_subviewProperties == subviewProperties) {
        return;
    }
    
   // _subviewProperties = subviewProperties;

    if(((subviewProperties & MessageViewSubviewPropertyImageView) == MessageViewSubviewPropertyImageView) && self.imageView == nil) {
        
        self.imageView                        = [UIImageView new];
        self.imageView.contentMode            = UIViewContentModeCenter;
        self.imageView.userInteractionEnabled = YES;
        
        [self addSubview:self.imageView];
        
    } else if(((subviewProperties & MessageViewSubviewPropertyImageView) != MessageViewSubviewPropertyImageView) && self.imageView) {
        
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        
    }
        
    if(((subviewProperties & MessageViewSubviewPropertyTextLabel) == MessageViewSubviewPropertyTextLabel) && self.textLabel == nil) {
        
        self.textLabel      = [UILabel new];
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.numberOfLines = 3;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.textLabel];
        
    } else if(((subviewProperties & MessageViewSubviewPropertyTextLabel) != MessageViewSubviewPropertyTextLabel) && self.textLabel) {
        
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
        
    }
    
    if(((subviewProperties & MessageViewSubviewPropertyDetailTextLabel) == MessageViewSubviewPropertyDetailTextLabel) && self.detailTextLabel == nil) {
        
        self.detailTextLabel               = [UILabel new];
        self.detailTextLabel.font          = [UIFont systemFontOfSize:15.0];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:.75];

        [self addSubview:self.detailTextLabel];
        
    } else if(((subviewProperties & MessageViewSubviewPropertyDetailTextLabel) != MessageViewSubviewPropertyDetailTextLabel) && self.detailTextLabel) {
        
        [self.detailTextLabel removeFromSuperview];
        self.detailTextLabel = nil;
        
    }
    
    if(((subviewProperties & MessageViewSubviewPropertyButton) == MessageViewSubviewPropertyButton) && self.refreshButton == nil) {
        
//        self.refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        
//        [self.refreshButton setBackgroundColor:[UIColor grayColorLight:YES]];
//        [self.refreshButton.titleLabel setFont:[UIFont lightFontWithSize:16.0]];
//        [self.refreshButton setContentEdgeInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
//        [self.refreshButton setTintColor:[UIColor whiteColor]];
//        [self.refreshButton addTarget:self
//                        action:@selector(handleButtonTapped:)
//              forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview:self.refreshButton];
        
    } else if(((subviewProperties & MessageViewSubviewPropertyButton) != MessageViewSubviewPropertyButton) && self.refreshButton) {
        
        [self.refreshButton removeFromSuperview];
        self.refreshButton = nil;
        
    }
}

#pragma mark - Button methods

- (void)handleButtonTapped:(id)sender
{
    if(self.buttonTapBlock) {
        self.buttonTapBlock();
    }
}


@end
