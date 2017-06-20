//
//  DFSPSpnnerTransitioning.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/16/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSpnnerTransitioning.h"

@implementation DFSPSpnnerTransitioning
//===================================================================
// - UIViewControllerAnimatedTransitioning
//===================================================================

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [inView addSubview:toVC.view];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [toVC.view setFrame:CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    [UIView animateWithDuration:0.25f animations:^{
        [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    } completion:^(BOOL finished_) {
        [transitionContext completeTransition:YES];
    }];
}

@end
