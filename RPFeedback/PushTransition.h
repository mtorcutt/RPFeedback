//
//  MOPushTransition.h
//  Stacks
//
//  Created by Michael Orcutt on 10/19/14.
//  Copyright (c) 2014 Michael Orcutt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end
