//
//  PaperFoldViewController.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "PaperFoldViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PaperFoldViewController
@synthesize contentView = _contentView;
@synthesize animationTimer = _animationTimer;

@synthesize leftFoldView = _leftFoldView;
CGFloat const kLeftViewWidth = 100.0;

@synthesize rightFoldView = _rightFoldView;
CGFloat const kRightViewWidth = 240.0;
CGFloat const kRightViewPullFactor = 0.9;
NSInteger const kRightViewFoldCount = 4;

- (id)init
{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:_contentView];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onContentViewPanned:)];
        [_contentView addGestureRecognizer:panGestureRecognizer];

        [self.view setBackgroundColor:[UIColor darkGrayColor]];
        
        _leftFoldView = [[FoldView alloc] initWithFrame:CGRectMake(0,0,kLeftViewWidth,[self.view bounds].size.height)];
        [self.view insertSubview:_leftFoldView belowSubview:_contentView];
        
        _rightFoldView = [[MultiFoldView alloc] initWithFrame:CGRectMake([self.view bounds].size.width,0,kRightViewWidth,[self.view bounds].size.height) folds:kRightViewFoldCount pullFactor:kRightViewPullFactor];
        [_contentView addSubview:_rightFoldView];
    }
    return self;
}

- (void)onContentViewPanned:(UIPanGestureRecognizer*)gesture
{
    CGPoint point = [gesture translationInView:self.view];
    
    if ([gesture state]==UIGestureRecognizerStateBegan)
    {
        [_animationTimer invalidate];
    }
    
    if ([gesture state]==UIGestureRecognizerStateChanged)
    {
        [self animateWhenPanned:point];
    }
    else if ([gesture state]==UIGestureRecognizerStateEnded)
    {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(restoreView:) userInfo:nil repeats:YES];
        
    }
}

- (void)animateWhenPanned:(CGPoint)point
{
    float x = point.x;
    if (x>0)
    {
        if (x>kLeftViewWidth)
        {
            x = kLeftViewWidth;
        }
        
        [_contentView setTransform:CGAffineTransformMakeTranslation(x, 0)];
        [_leftFoldView unfoldWithParentOffset:x];
    }
    else if (x<0)
    {
        float x1 = x;
        if (x1<-kRightViewWidth)
        {
            x1 = -kRightViewWidth;
        }
        [_contentView setTransform:CGAffineTransformMakeTranslation(x1, 0)];
        [_rightFoldView unfoldWithParentOffset:x];
    }
}

- (void)restoreView:(NSTimer*)timer
{
    CGAffineTransform transform = [_contentView transform];
    float x = transform.tx/4*3;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [_contentView setTransform:transform];
    
    if ((x>=0 && x<5) || (x<=0 && x>-5))
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(0, 0);
        [_contentView setTransform:transform];
    }
    
    [self animateWhenPanned:CGPointMake(_contentView.frame.origin.x, 0)];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
