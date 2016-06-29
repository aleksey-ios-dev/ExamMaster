//
//  TSTTransitionViewController.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/29/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTTransitionViewController.h"

static const NSTimeInterval TSTAnimationDuration = 0.3;

@interface TSTTransitionViewController ()

@property (nonatomic, strong, readwrite) UIViewController *presentedController;

@end

@implementation TSTTransitionViewController


- (void)showViewController:(UIViewController *)controller animated:(BOOL)animated {
    [self transitionToViewController:controller
                  fromViewController:self.presentedController
                         withOptions:UIViewAnimationOptionTransitionCrossDissolve
                            animated:animated
                          completion:^(BOOL finished) {
                              self.presentedController = controller;
                          }];
}

- (void)transitionToViewController:(UIViewController *)toViewController
                fromViewController:(UIViewController *)fromViewController
                       withOptions:(UIViewAnimationOptions)options
                          animated:(BOOL)animated
                        completion:(void(^)(BOOL finished))completionBlock {
    
    UIViewAnimationOptions animationOptions = options |
    UIViewAnimationOptionLayoutSubviews |
    UIViewAnimationOptionAllowAnimatedContent |
    UIViewAnimationOptionOverrideInheritedOptions;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    toViewController.view.frame = self.view.bounds;
    toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    fromViewController.view.frame = self.view.bounds;
    fromViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    void(^completion)(BOOL finished) = ^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];

        if (completionBlock) {
            completionBlock(finished);
        }
    };
    
    if (animated) {
        if (fromViewController) {
            
            [UIView transitionFromView:fromViewController.view
                                toView:toViewController.view
                              duration:TSTAnimationDuration
                               options:animationOptions
                            completion:completion];
            
        }
        else {
            
            [UIView transitionWithView:self.view
                              duration:TSTAnimationDuration
                               options:animationOptions
                            animations:^{
                                [self.view addSubview:toViewController.view];
                            } completion:completion];
        }
    }
    else {
        [fromViewController.view removeFromSuperview];
        [self.view addSubview:toViewController.view];
        completion(YES);
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self.childViewControllers firstObject];
}

@end
