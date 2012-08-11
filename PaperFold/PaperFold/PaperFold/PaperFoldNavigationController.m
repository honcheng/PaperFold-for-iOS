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
    [self.paperFoldView setRightFoldContentView:self.rightViewController.view rightViewFoldCount:rightViewFoldCount rightViewPullFactor:rightViewPullFactor];
}

- (void)setLeftViewController:(UIViewController *)leftViewController width:(float)width
{
    _leftViewController = leftViewController;
    
    [self.leftViewController.view setFrame:CGRectMake(0,0,width,[self.view bounds].size.height)];
    [self.paperFoldView setLeftFoldContentView:self.leftViewController.view];
}

- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState
{
    if (paperFoldState==PaperFoldStateDefault)
    {
        [self.leftViewController viewWillAppear:YES];
        [self.leftViewController viewDidAppear:YES];
    }
    else if (paperFoldState==PaperFoldStateLeftUnfolded)
    {
        [self.rootViewController viewWillAppear:YES];
        [self.rootViewController viewDidAppear:YES];
    }
    else if (paperFoldState==PaperFoldStateRightUnfolded)
    {
        [self.rightViewController viewWillAppear:YES];
        [self.rightViewController viewDidAppear:YES];
    }
}

@end
