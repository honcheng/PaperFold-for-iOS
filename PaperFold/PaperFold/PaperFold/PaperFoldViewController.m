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
@synthesize state = _state;

@synthesize leftFoldView = _leftFoldView;
CGFloat const kLeftViewUnfoldThreshold = 0.3;

@synthesize rightFoldView = _rightFoldView;
CGFloat const kRightViewUnfoldThreshold = 0.3;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self.view setBackgroundColor:[UIColor darkGrayColor]];
        
        _contentView = [[TouchThroughUIView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:_contentView];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onContentViewPanned:)];
        [_contentView addGestureRecognizer:panGestureRecognizer];
        
        _state = PaperFoldStateDefault;
    }
    return self;
}

- (void)setLeftFoldContentView:(UIView*)view
{
    if (_leftFoldView) [_leftFoldView removeFromSuperview];
    
    _leftFoldView = [[FoldView alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width,[self.view bounds].size.height)];
    [self.view insertSubview:_leftFoldView belowSubview:_contentView];
    [_leftFoldView setContent:view];
}

- (void)setRightFoldContentView:(UIView*)view rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor
{
    _rightFoldView = [[MultiFoldView alloc] initWithFrame:CGRectMake([self.view bounds].size.width,0,view.frame.size.width,[self.view bounds].size.height) folds:rightViewFoldCount pullFactor:rightViewPullFactor];
    [_contentView addSubview:_rightFoldView];
    
    [_rightFoldView setContent:view];
}

- (void)onContentViewPanned:(UIPanGestureRecognizer*)gesture
{
    // cancel gesture if another animation has not finished yet
    if ([_animationTimer isValid]) return;
    
    CGPoint point = [gesture translationInView:self.view];
    
    if ([gesture state]==UIGestureRecognizerStateChanged)
    {
        if (_state==PaperFoldStateDefault)
        {
            // animate folding when panned
            [self animateWhenPanned:point];
        }
        else if (_state==PaperFoldStateLeftUnfolded)
        {
            CGPoint adjustedPoint = CGPointMake(point.x + _leftFoldView.frame.size.width, point.y);
            [self animateWhenPanned:adjustedPoint];
        }
        else if (_state==PaperFoldStateRightUnfolded)
        {
            CGPoint adjustedPoint = CGPointMake(point.x - _rightFoldView.frame.size.width, point.y);
            [self animateWhenPanned:adjustedPoint];
        }
        
    }
    else if ([gesture state]==UIGestureRecognizerStateEnded || [gesture state]==UIGestureRecognizerStateCancelled)
    {
        float x = point.x;
        if (x>=0.0) // offset to the right
        {
            if ( (x>=kLeftViewUnfoldThreshold*_leftFoldView.frame.size.width && _state==PaperFoldStateDefault) || [_contentView frame].origin.x==_leftFoldView.frame.size.width) 
            {
                
                // if offset more than threshold, open fully
                _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldLeftView:) userInfo:nil repeats:YES];
                return;
            }
        }
        else if (x<0)
        {
            if ((x<=-kRightViewUnfoldThreshold*_rightFoldView.frame.size.width && _state==PaperFoldStateDefault) || [_contentView frame].origin.x==-_rightFoldView.frame.size.width)
            {
                // if offset more than threshold, open fully
                _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldRightView:) userInfo:nil repeats:YES];
                return;
            }
        }
        
        // after panning completes
        // if offset does not exceed threshold
        // use NSTimer to create manual animation to restore view
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(restoreView:) userInfo:nil repeats:YES];
        
    }
}

- (void)animateWhenPanned:(CGPoint)point
{
    float x = point.x;
    // if offset to the right, show the left view
    // if offset to the left, show the right multi-fold view

    if (x>0.0)
    {
        // set the limit of the right offset
        if (x>=_leftFoldView.frame.size.width)
        {
            _state = PaperFoldStateLeftUnfolded;
            x = _leftFoldView.frame.size.width;
        }
        [_contentView setTransform:CGAffineTransformMakeTranslation(x, 0)];
        [_leftFoldView unfoldWithParentOffset:x];
    }
    else if (x<0.0)
    {
        // set the limit of the left offset
        // original x value not changed, to be sent to multi-fold view
        float x1 = x;
        if (x1<=-_rightFoldView.frame.size.width)
        {
            _state = PaperFoldStateRightUnfolded;
            x1 = -_rightFoldView.frame.size.width;
        }
        [_contentView setTransform:CGAffineTransformMakeTranslation(x1, 0)];
        [_rightFoldView unfoldWithParentOffset:x];
    }
    else 
    {
        [_contentView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [_leftFoldView unfoldWithParentOffset:x];
        [_rightFoldView unfoldWithParentOffset:x];
        _state = PaperFoldStateDefault;
    }
}

// unfold the left view
- (void)unfoldLeftView:(NSTimer*)timer
{
    CGAffineTransform transform = [_contentView transform];
    float x = transform.tx + (_leftFoldView.frame.size.width-transform.tx)/4;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [_contentView setTransform:transform];
    if (x>=_leftFoldView.frame.size.width-2)
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(_leftFoldView.frame.size.width, 0);
        [_contentView setTransform:transform];
    }
    
    // use the x value to animate folding
    [self animateWhenPanned:CGPointMake(_contentView.frame.origin.x, 0)];
}

// unfold the right view
- (void)unfoldRightView:(NSTimer*)timer
{
    CGAffineTransform transform = [_contentView transform];
    float x = transform.tx - (transform.tx+_rightFoldView.frame.size.width)/8;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [_contentView setTransform:transform];

    if (x<=-_rightFoldView.frame.size.width+5)
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(-_rightFoldView.frame.size.width, 0);
        [_contentView setTransform:transform];
    }
    
    // use the x value to animate folding
    [self animateWhenPanned:CGPointMake(_contentView.frame.origin.x, 0)];
}

// restore contentView back to original position
- (void)restoreView:(NSTimer*)timer
{
    CGAffineTransform transform = [_contentView transform];
    // restoring the x position 3/4 of the last x translation
    float x = transform.tx/4*3;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [_contentView setTransform:transform];
    
    // if -5<x<5, stop timer animation
    if ((x>=0 && x<5) || (x<=0 && x>-5))
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(0, 0);
        [_contentView setTransform:transform];
        [self animateWhenPanned:CGPointMake(0, 0)];
    }
    else
    {
        // use the x value to animate folding
        [self animateWhenPanned:CGPointMake(_contentView.frame.origin.x, 0)];
    }
    
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
