//
//  DFSPSpinnerTransitionDelegate.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/16/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSpinnerTransitionDelegate.h"
#import "DFSPSpnnerTransitioning.h"

@implementation DFSPSpinnerTransitionDelegate
//===================================================================
// - UIViewControllerTransitioningDelegate
//===================================================================

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    DFSPSpnnerTransitioning *controller = [[DFSPSpnnerTransitioning alloc]init];
    controller.isPresenting = YES;
    return controller;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    //I will fix it later.
    //    DFSPSpnnerTransitioning *controller = [[DFSPSpnnerTransitioning alloc]init];
    //    controller.isPresenting = NO;
    //    return controller;
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

@end
