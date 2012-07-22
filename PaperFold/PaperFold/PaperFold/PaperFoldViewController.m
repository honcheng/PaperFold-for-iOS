/**
 * Copyright (c) 2012 Muh Hon Cheng
 * Created by honcheng on 6/2/12.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 * IN CONNECTION WITH THE SOFTWARE OR
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2012	Muh Hon Cheng
 * @version
 *
 */


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
    if (self.leftFoldView) [self.leftFoldView removeFromSuperview];
    
    self.leftFoldView = [[FoldView alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width,[self.view bounds].size.height)];
    [self.view insertSubview:self.leftFoldView belowSubview:self.contentView];
    [self.leftFoldView setContent:view];
}

- (void)setRightFoldContentView:(UIView*)view rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor
{
    self.rightFoldView = [[MultiFoldView alloc] initWithFrame:CGRectMake([self.view bounds].size.width,0,view.frame.size.width,[self.view bounds].size.height) folds:rightViewFoldCount pullFactor:rightViewPullFactor];
    [self.contentView addSubview:self.rightFoldView];
    
    [self.rightFoldView setContent:view];
}

- (void)onContentViewPanned:(UIPanGestureRecognizer*)gesture
{
    // cancel gesture if another animation has not finished yet
    if ([self.animationTimer isValid]) return;
    
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
            CGPoint adjustedPoint = CGPointMake(point.x + self.leftFoldView.frame.size.width, point.y);
            [self animateWhenPanned:adjustedPoint];
        }
        else if (_state==PaperFoldStateRightUnfolded)
        {
            CGPoint adjustedPoint = CGPointMake(point.x - self.rightFoldView.frame.size.width, point.y);
            [self animateWhenPanned:adjustedPoint];
        }
        
    }
    else if ([gesture state]==UIGestureRecognizerStateEnded || [gesture state]==UIGestureRecognizerStateCancelled)
    {
        float x = point.x;
        if (x>=0.0) // offset to the right
        {
            if ( (x>=kLeftViewUnfoldThreshold*self.leftFoldView.frame.size.width && _state==PaperFoldStateDefault) || [self.contentView frame].origin.x==self.leftFoldView.frame.size.width) 
            {
                
                // if offset more than threshold, open fully
                self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldLeftView:) userInfo:nil repeats:YES];
                return;
            }
        }
        else if (x<0)
        {
            if ((x<=-kRightViewUnfoldThreshold*self.rightFoldView.frame.size.width && _state==PaperFoldStateDefault) || [self.contentView frame].origin.x==-self.rightFoldView.frame.size.width)
            {
                // if offset more than threshold, open fully
                self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldRightView:) userInfo:nil repeats:YES];
                return;
            }
        }
        
        // after panning completes
        // if offset does not exceed threshold
        // use NSTimer to create manual animation to restore view
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(restoreView:) userInfo:nil repeats:YES];
        
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
        if (x>=self.leftFoldView.frame.size.width)
        {
            self.state = PaperFoldStateLeftUnfolded;
            x = self.leftFoldView.frame.size.width;
        }
        [self.contentView setTransform:CGAffineTransformMakeTranslation(x, 0)];
        [self.leftFoldView unfoldWithParentOffset:x];
    }
    else if (x<0.0)
    {
        // set the limit of the left offset
        // original x value not changed, to be sent to multi-fold view
        float x1 = x;
        if (x1<=-self.rightFoldView.frame.size.width)
        {
            self.state = PaperFoldStateRightUnfolded;
            x1 = -self.rightFoldView.frame.size.width;
        }
        [self.contentView setTransform:CGAffineTransformMakeTranslation(x1, 0)];
        [self.rightFoldView unfoldWithParentOffset:x];
    }
    else 
    {
        [self.contentView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [self.leftFoldView unfoldWithParentOffset:x];
        [self.rightFoldView unfoldWithParentOffset:x];
        self.state = PaperFoldStateDefault;
    }
}

// unfold the left view
- (void)unfoldLeftView:(NSTimer*)timer
{
    CGAffineTransform transform = [self.contentView transform];
    float x = transform.tx + (self.leftFoldView.frame.size.width-transform.tx)/4;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [self.contentView setTransform:transform];
    if (x>=self.leftFoldView.frame.size.width-2)
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(self.leftFoldView.frame.size.width, 0);
        [self.contentView setTransform:transform];
    }
    
    // use the x value to animate folding
    [self animateWhenPanned:CGPointMake(self.contentView.frame.origin.x, 0)];
}

// unfold the right view
- (void)unfoldRightView:(NSTimer*)timer
{
    CGAffineTransform transform = [self.contentView transform];
    float x = transform.tx - (transform.tx+self.rightFoldView.frame.size.width)/8;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [self.contentView setTransform:transform];

    if (x<=-self.rightFoldView.frame.size.width+5)
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(-self.rightFoldView.frame.size.width, 0);
        [self.contentView setTransform:transform];
    }
    
    // use the x value to animate folding
    [self animateWhenPanned:CGPointMake(self.contentView.frame.origin.x, 0)];
}

// restore contentView back to original position
- (void)restoreView:(NSTimer*)timer
{
    CGAffineTransform transform = [self.contentView transform];
    // restoring the x position 3/4 of the last x translation
    float x = transform.tx/4*3;
    transform = CGAffineTransformMakeTranslation(x, 0);
    [self.contentView setTransform:transform];
    
    // if -5<x<5, stop timer animation
    if ((x>=0 && x<5) || (x<=0 && x>-5))
    {
        [timer invalidate];
        transform = CGAffineTransformMakeTranslation(0, 0);
        [self.contentView setTransform:transform];
        [self animateWhenPanned:CGPointMake(0, 0)];
    }
    else
    {
        // use the x value to animate folding
        [self animateWhenPanned:CGPointMake(self.contentView.frame.origin.x, 0)];
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
