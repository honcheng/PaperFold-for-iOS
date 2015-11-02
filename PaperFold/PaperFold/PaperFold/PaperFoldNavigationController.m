//
//  PaperFoldNavigationController.m
//  PaperFold-ContainmentView
//
//  Created by honcheng on 10/8/12.
//  Copyright (c) 2012 honcheng. All rights reserved.
//

#import "PaperFoldNavigationController.h"

@interface PaperFoldNavigationController ()

@end

@implementation PaperFoldNavigationController

- (void)awakeFromNib {
    [super awakeFromNib];

    if (self.rootViewControllerID) {
        self.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.rootViewControllerID];
        [self initWithRootViewController:self.rootViewController];
    }
    if (self.leftViewControllerID) {
        int leftWidth = 150;
        
        if (self.leftViewWidth) leftWidth = [self.leftViewWidth intValue];

        self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.leftViewControllerID];
        [self setLeftViewController:self.leftViewController width:leftWidth];
    }
    if (self.rightViewControllerID) {
        int rightWidth = 250;
        int rightFoldCount = 3;
        float rightPullFactor = .9f;
        
        if (self.rightViewWidth) rightWidth = [self.rightViewWidth intValue];
        if (self.rightViewFoldCount) rightFoldCount = [self.rightViewFoldCount intValue];
        if (self.rightViewPullFactor) rightPullFactor = [self.rightViewPullFactor floatValue];
        
        self.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.rightViewControllerID];
        [self setRightViewController:self.rightViewController width:rightWidth rightViewFoldCount:rightFoldCount rightViewPullFactor:rightPullFactor];
    }
    
}

- (id)initWithRootViewController:(UIViewController*)rootViewController
{
    self = [super init];
    if (self) {
        
        [self.view setAutoresizesSubviews:YES];
        
        _paperFoldView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [self.view addSubview:_paperFoldView];
        [_paperFoldView setDelegate:self];
        [_paperFoldView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        _rootViewController = rootViewController;
        [_rootViewController.view setFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_rootViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [_paperFoldView setCenterContentView:_rootViewController.view];
    }
    return self;
}

- (void)setRightViewController:(UIViewController*)rightViewController width:(float)width rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor
{
    _rightViewController = rightViewController;
    
    [self.rightViewController.view setFrame:CGRectMake(0,0,width,[self.view bounds].size.height)];
    [self.paperFoldView setRightFoldContentView:self.rightViewController.view foldCount:rightViewFoldCount pullFactor:rightViewPullFactor];
}

- (void)setLeftViewController:(UIViewController *)leftViewController width:(float)width
{
    _leftViewController = leftViewController;
    
    [self.leftViewController.view setFrame:CGRectMake(0,0,width,[self.view bounds].size.height)];
    [self.paperFoldView setLeftFoldContentView:self.leftViewController.view foldCount:3 pullFactor:0.9];
}

- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState
{
    if (paperFoldState==PaperFoldStateDefault)
    {
        if (self.leftViewController) {
            [self.leftViewController viewWillDisappear:YES];
            [self.leftViewController viewDidDisappear:YES];
        }

        if (self.rightViewController) {
            [self.rightViewController viewWillDisappear:YES];
            [self.rightViewController viewDidDisappear:YES];
        }

        [self.rootViewController viewWillAppear:YES];
        [self.rootViewController viewDidAppear:YES];
    }
    else if (paperFoldState==PaperFoldStateLeftUnfolded)
    {
        [self.rootViewController viewWillDisappear:YES];
        [self.rootViewController viewDidDisappear:YES];

        [self.leftViewController viewWillAppear:YES];
        [self.leftViewController viewDidAppear:YES];
    }
    else if (paperFoldState==PaperFoldStateRightUnfolded)
    {   
        [self.rootViewController viewWillDisappear:YES];
        [self.rootViewController viewDidDisappear:YES];
        
        [self.rightViewController viewWillAppear:YES];
        [self.rightViewController viewDidAppear:YES];
    }
}

@end
