//
//  TSTTransitionViewController.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/29/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTTransitionViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *presentedController;

- (void)showViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
