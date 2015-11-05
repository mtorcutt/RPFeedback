//
//  MultipleLineTitle.m
//
//  Created by Michael Orcutt on 9/7/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "MultipleLineTitle.h"

@implementation MultipleLineTitle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textLabel               = [UILabel new];
        self.textLabel.textColor     = [UIColor whiteColor];
        self.textLabel.font          = [UIFont systemFontOfSize:24.0];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.textLabel];

        self.detailTextLabel               = [UILabel new];
        self.detailTextLabel.textColor     = [UIColor colorWithWhite:1.0 alpha:.75];
        self.detailTextLabel.font          = [UIFont systemFontOfSize:16.0];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:self.detailTextLabel];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    
    CGRect textLabelFrame
    = CGRectZero;
    textLabelFrame.size
    = [self.textLabel.text boundingRectWithSize:boundsSize
                                        options:(NSStringDrawingUsesFontLeading |
                                                 NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{ NSFontAttributeName : self.textLabel.font }
                                        context:nil].size;
    
    CGRect detailTextLabelFrame
    = CGRectZero;
    detailTextLabelFrame.size
    = [self.detailTextLabel.text boundingRectWithSize:boundsSize
                                              options:(NSStringDrawingUsesFontLeading |
                                                 NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{ NSFontAttributeName : self.detailTextLabel.font }
                                              context:nil].size;
    
    textLabelFrame.origin.x = (boundsSize.width - textLabelFrame.size.width)/2.0;
    
    detailTextLabelFrame.origin.x = (boundsSize.width - detailTextLabelFrame.size.width)/2.0;
    detailTextLabelFrame.origin.y = textLabelFrame.size.height;
    
    self.textLabel.frame       = textLabelFrame;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

- (void)sizeToFit {
    [super sizeToFit];
    
    CGRect frame = self.frame;
    
    CGSize detailTextLabelSize
    = [self.detailTextLabel.text boundingRectWithSize:frame.size
                                              options:(NSStringDrawingUsesFontLeading |
                                                       NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{ NSFontAttributeName : self.detailTextLabel.font }
                                              context:nil].size;
    CGSize textLabelSize
    = [self.textLabel.text boundingRectWithSize:frame.size
                                        options:(NSStringDrawingUsesFontLeading |
                                                 NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{ NSFontAttributeName : self.textLabel.font }
                                        context:nil].size;
    
    frame.size.width  = MAX(detailTextLabelSize.width, textLabelSize.width);
    frame.size.height = (textLabelSize.height + detailTextLabelSize.height);
    
    self.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    
    CGRect frame = CGRectZero;

    CGSize detailTextLabelSize
    = [self.detailTextLabel.text boundingRectWithSize:size
                                              options:(NSStringDrawingUsesFontLeading |
                                                       NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{ NSFontAttributeName : self.detailTextLabel.font }
                                              context:nil].size;
    CGSize textLabelSize
    = [self.textLabel.text boundingRectWithSize:size
                                        options:(NSStringDrawingUsesFontLeading |
                                                 NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{ NSFontAttributeName : self.textLabel.font }
                                        context:nil].size;
    
    frame.size.width  = MAX(detailTextLabelSize.width, textLabelSize.width);
    frame.size.height = (textLabelSize.height + detailTextLabelSize.height);

    return frame.size;
}

@end
