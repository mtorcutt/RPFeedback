//
//  MOPushTransition.m
//  Stacks
//
//  Created by Michael Orcutt on 10/19/14.
//  Copyright (c) 2014 Michael Orcutt. All rights reserved.
//

#import "PushTransition.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    CGRect containerViewFrame = containerView.frame;
    
    CGRect toViewControllerFrame;
    toViewControllerFrame.size = containerViewFrame.size;
    CGRect fromViewControllerFrame;
    fromViewControllerFrame.size = containerViewFrame.size;

    if(self.operation == UINavigationControllerOperationPush) {
        toViewControllerFrame.origin.x = containerViewFrame.size.width;
    } else {
        toViewControllerFrame.origin.x = -containerViewFrame.size.width;
    }
    
    toViewController.view.frame = toViewControllerFrame;
    
    [containerView addSubview:toViewController.view];
    
    toViewControllerFrame.origin.x = 0.0;
    
    if(self.operation == UINavigationControllerOperationPush) {
        fromViewControllerFrame.origin.x = -containerViewFrame.size.width;
    } else {
        fromViewControllerFrame.origin.x = containerViewFrame.size.width;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = fromViewControllerFrame;
        toViewController.view.frame   = toViewControllerFrame;
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
