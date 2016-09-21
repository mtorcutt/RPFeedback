//
//  LocationManagerTableViewCell.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "TransparentTableViewCell.h"

@implementation TransparentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle          = UITableViewCellSelectionStyleNone;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor     = [UIColor whiteColor];
        self.backgroundColor         = [UIColor clearColor];
    }
    return self;
}

@end
