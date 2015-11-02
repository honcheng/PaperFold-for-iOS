//
//  PaperFoldNavigationController.h
//  PaperFold-ContainmentView
//
//  Created by honcheng on 10/8/12.
//  Copyright (c) 2012 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperFoldView.h"

@interface PaperFoldNavigationController : UIViewController <PaperFoldViewDelegate>
@property (nonatomic, copy, readonly) NSString *rootViewControllerID, *leftViewControllerID, *rightViewControllerID;
@property (nonatomic, copy, readonly) NSNumber *leftViewWidth;
@property (nonatomic, copy, readonly) NSNumber *rightViewWidth, *rightViewFoldCount, *rightViewPullFactor;
@property (nonatomic, strong) UIViewController *rootViewController, *leftViewController, *rightViewController;
@property (nonatomic, strong) PaperFoldView *paperFoldView;
- (id)initWithRootViewController:(UIViewController*)rootViewController;
- (void)setLeftViewController:(UIViewController *)leftViewController width:(float)width;
- (void)setRightViewController:(UIViewController*)rightViewController width:(float)width rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor;
@end
