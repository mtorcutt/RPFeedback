//
//  Location.h
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RPLocation : JSONModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lineOne;
@property (nonatomic, strong) NSString *lineTwo;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, readonly) NSAttributedString *addressAtrributedString;

@end
