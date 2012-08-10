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


#import "PaperFoldView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PaperFoldView

CGFloat const kLeftViewUnfoldThreshold = 0.3;
CGFloat const kRightViewUnfoldThreshold = 0.3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor darkGrayColor]];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        _contentView = [[TouchThroughUIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self addSubview:_contentView];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizesSubviews:YES];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onContentViewPanned:)];
        [_contentView addGestureRecognizer:panGestureRecognizer];
        
        _state = PaperFoldStateDefault;
        _lastState = _state;
        _enableRightFoldDragging = YES;
        _enableLeftFoldDragging = YES;
    }
    return self;
}

- (void)setCenterContentView:(UIView*)view
{
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.contentView addSubview:view];
}

- (void)setLeftFoldContentView:(UIView*)view
{
    if (self.leftFoldView) [self.leftFoldView removeFromSuperview];

    self.leftFoldView = [[FoldView alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width,self.frame.size.height)];
    [self.leftFoldView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self insertSubview:self.leftFoldView belowSubview:self.contentView];
    [self.leftFoldView setContent:view];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self setPaperFoldState:PaperFoldStateDefault];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-1,0,1,self.frame.size.height)];
    [line setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:line];
    [line setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.5]];
}

- (void)setRightFoldContentView:(UIView*)view rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor
{
    self.rightFoldView = [[MultiFoldView alloc] initWithFrame:CGRectMake(self.frame.size.width,0,view.frame.size.width,self.frame.size.height) folds:rightViewFoldCount pullFactor:rightViewPullFactor];
    [self.rightFoldView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.rightFoldView];
    [self.rightFoldView setContent:view];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self setPaperFoldState:PaperFoldStateDefault];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width,0,1,self.frame.size.height)];
    [line setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:line];
    [line setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight];
    [line setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.5]];
}

- (void)onContentViewPanned:(UIPanGestureRecognizer*)gesture
{
    // cancel gesture if another animation has not finished yet
    if ([self.animationTimer isValid]) return;

    CGPoint point = [gesture translationInView:self];
    
    if ([gesture state]==UIGestureRecognizerStateChanged)
    {
        if (_state==PaperFoldStateDefault)
        {
            // animate folding when panned
            [self animateWithContentOffset:point panned:YES];
        }
        else if (_state==PaperFoldStateLeftUnfolded)
        {
            CGPoint adjustedPoint = CGPointMake(point.x + self.leftFoldView.frame.size.width, point.y);
            [self animateWithContentOffset:adjustedPoint panned:YES];
        }
        else if (_state==PaperFoldStateRightUnfolded)
        {
            CGPoint adjustedPoint = CGPointMake(point.x - self.rightFoldView.frame.size.width, point.y);
            [self animateWithContentOffset:adjustedPoint panned:YES];
        }
        
    }
    else if ([gesture state]==UIGestureRecognizerStateEnded || [gesture state]==UIGestureRecognizerStateCancelled)
    {
        float x = point.x;
        if (x>=0.0) // offset to the right
        {
            if ( (x>=kLeftViewUnfoldThreshold*self.leftFoldView.frame.size.width && _state==PaperFoldStateDefault) || [self.contentView frame].origin.x==self.leftFoldView.frame.size.width)
            {
                if (self.enableLeftFoldDragging)
                {
                    // if offset more than threshold, open fully
                    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldLeftView:) userInfo:nil repeats:YES];
                    return;
                }
            }
        }
        else if (x<0)
        {
            if ((x<=-kRightViewUnfoldThreshold*self.rightFoldView.frame.size.width && _state==PaperFoldStateDefault) || [self.contentView frame].origin.x==-self.rightFoldView.frame.size.width)
            {
                if (self.enableRightFoldDragging)
                {
                    // if offset more than threshold, open fully
                    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldRightView:) userInfo:nil repeats:YES];
                    return;
                }
            }
        }
        
        // after panning completes
        // if offset does not exceed threshold
        // use NSTimer to create manual animation to restore view
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(restoreView:) userInfo:nil repeats:YES];
        
    }
}

- (void)animateWithContentOffset:(CGPoint)point panned:(BOOL)panned
{
    float x = point.x;
    // if offset to the right, show the left view
    // if offset to the left, show the right multi-fold view

    if (self.state!=self.lastState) self.lastState = self.state;

    if (x>0.0)
    {
        if (self.enableLeftFoldDragging || !panned)
        {
            // set the limit of the right offset
            if (x>=self.leftFoldView.frame.size.width)
            {
                self.lastState = self.state;
                self.state = PaperFoldStateLeftUnfolded;
                x = self.leftFoldView.frame.size.width;
            }
            [self.contentView setTransform:CGAffineTransformMakeTranslation(x, 0)];
            [self.leftFoldView unfoldWithParentOffset:x];
            
            if ([self.delegate respondsToSelector:@selector(paperFoldView:viewDidOffset:)])
            {
                [self.delegate paperFoldView:self viewDidOffset:CGPointMake(x,0)];
            }
        }
    }
    else if (x<0.0)
    {
        if (self.enableRightFoldDragging || !panned)
        {
            // set the limit of the left offset
            // original x value not changed, to be sent to multi-fold view
            float x1 = x;
            if (x1<=-self.rightFoldView.frame.size.width)
            {
                self.lastState = self.state;
                self.state = PaperFoldStateRightUnfolded;
                x1 = -self.rightFoldView.frame.size.width;
            }
            [self.contentView setTransform:CGAffineTransformMakeTranslation(x1, 0)];
            [self.rightFoldView unfoldWithParentOffset:x];
            
            if ([self.delegate respondsToSelector:@selector(paperFoldView:viewDidOffset:)])
            {
                [self.delegate paperFoldView:self viewDidOffset:CGPointMake(x,0)];
            }
        }
    }
    else 
    {
        [self.contentView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [self.leftFoldView unfoldWithParentOffset:x];
        [self.rightFoldView unfoldWithParentOffset:x];
        self.state = PaperFoldStateDefault;
        
        if ([self.delegate respondsToSelector:@selector(paperFoldView:viewDidOffset:)])
        {
            [self.delegate paperFoldView:self viewDidOffset:CGPointMake(x,0)];
        }
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
        
        if (self.lastState!=PaperFoldStateLeftUnfolded && [self.delegate respondsToSelector:@selector(paperFoldView:didFoldAutomatically:toState:)])
        {
            [self.delegate paperFoldView:self didFoldAutomatically:self.isAutomatedFolding toState:PaperFoldStateLeftUnfolded];
        }
        [self setIsAutomatedFolding:NO];
    }
    
    // use the x value to animate folding
    [self animateWithContentOffset:CGPointMake(self.contentView.frame.origin.x, 0) panned:NO];
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
        
        if (self.lastState!=PaperFoldStateRightUnfolded && [self.delegate respondsToSelector:@selector(paperFoldView:didFoldAutomatically:toState:)])
        {
            [self.delegate paperFoldView:self didFoldAutomatically:self.isAutomatedFolding toState:PaperFoldStateRightUnfolded];
        }
        [self setIsAutomatedFolding:NO];
    }
    
    // use the x value to animate folding
    [self animateWithContentOffset:CGPointMake(self.contentView.frame.origin.x, 0) panned:NO];
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
        [self animateWithContentOffset:CGPointMake(0, 0) panned:NO];
        
        if (self.lastState!=PaperFoldStateDefault && [self.delegate respondsToSelector:@selector(paperFoldView:didFoldAutomatically:toState:)])
        {
            [self.delegate paperFoldView:self didFoldAutomatically:self.isAutomatedFolding toState:PaperFoldStateDefault];
        }
        [self setIsAutomatedFolding:NO];
    }
    else
    {
        // use the x value to animate folding
        [self animateWithContentOffset:CGPointMake(self.contentView.frame.origin.x, 0) panned:NO];
    }
}

- (void)setPaperFoldState:(PaperFoldState)state
{
    [self setIsAutomatedFolding:YES];
    if (state==PaperFoldStateDefault)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(restoreView:) userInfo:nil repeats:YES];
    }
    else if (state==PaperFoldStateLeftUnfolded)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldLeftView:) userInfo:nil repeats:YES];
    }
    else if (state==PaperFoldStateRightUnfolded)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldRightView:) userInfo:nil repeats:YES];
    }
}

- (void)unfoldLeftView
{
    [self setPaperFoldState:PaperFoldStateLeftUnfolded];
}

- (void)unfoldRightView
{
    [self setPaperFoldState:PaperFoldStateRightUnfolded];
}

- (void)restoreToCenter
{
    [self setPaperFoldState:PaperFoldStateDefault];
}

@end
