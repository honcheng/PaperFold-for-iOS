//
//  FoldView.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "FoldView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Screenshot.h"

@implementation FoldView
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;
@synthesize state = _state;
@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
        // foldview consists of leftView and rightView
        // set shadow direction of leftView and rightView such that the shadow falls on the fold in the middle
        
        // set anchor point of the leftView to the left edge
        _leftView = [[FacingView alloc] initWithFrame:CGRectMake(-1*frame.size.width/4,0,frame.size.width/2,frame.size.height)];
        [_leftView setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_leftView.layer setAnchorPoint:CGPointMake(0.0, 0.5)];
        [self addSubview:_leftView];
        [_leftView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.05],[UIColor colorWithWhite:0 alpha:0.6], nil]];
        
        // set anchor point of the rightView to the right edge
        _rightView = [[FacingView alloc] initWithFrame:CGRectMake(-1*frame.size.width/4,0,frame.size.width/2,frame.size.height)];
        [_rightView setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightView.layer setAnchorPoint:CGPointMake(1.0, 0.5)];
        [self addSubview:_rightView];
        [_rightView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.6],[UIColor colorWithWhite:0 alpha:0.05], nil]];
        
        // set perspective of the transformation
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.0;
        [self.layer setSublayerTransform:transform];
        
        // make sure the views are closed properly when initialized
        [_leftView.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, 1, 0)];
        [_rightView.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, 1, 0)];
    }
    return self;
}

- (void)unfoldViewToFraction:(CGFloat)fraction 
{
    float delta = asinf(fraction);
    
    // rotate leftView on the left edge of the view
	[_leftView.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta, 0, 1, 0)];

    // rotate rightView on the right edge of the view
    // translate rotated view to the left to join to the edge of the leftView
    CATransform3D transform1 = CATransform3DMakeTranslation(2*_leftView.frame.size.width, 0, 0);
    CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - delta, 0, -1, 0);
    CATransform3D transform = CATransform3DConcat(transform2, transform1);
    [_rightView.layer setTransform:transform];

    // fade in shadow when folding
    // fade out shadow when unfolding
    [_leftView.shadowView setAlpha:1-fraction];
    [_rightView.shadowView setAlpha:1-fraction];
}

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset
{
    CGFloat fraction = offset / self.frame.size.width;
    if (fraction < 0) fraction = 0;
    if (fraction > 1) fraction = 1;
    
    if (_state==FoldStateClosed && fraction>0)
    {
        _state = FoldStateTransition;
        [self foldWillOpen];
    }
    else if (_state==FoldStateOpened && fraction<1)
    {
        _state = FoldStateTransition;
        [self foldWillClose];
        
    }
    else if (_state==FoldStateTransition)
    {
        if (fraction==0)
        {
            _state = FoldStateClosed;
            [self foldDidClosed];
        }
        else if (fraction==1)
        {
            _state = FoldStateOpened;
            [self foldDidOpened];
        }
    }
}

- (void)unfoldWithParentOffset:(float)offset
{
    [self calculateFoldStateFromOffset:offset];
    
    CGFloat fraction = offset / self.frame.size.width;
    if (fraction < 0) fraction = 0;
    if (fraction > 1) fraction = 1;
    
    [self unfoldViewToFraction:fraction];
}

- (void)setImage:(UIImage*)image
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, image.size.width*image.scale/2, image.size.height*image.scale));
    [_leftView.layer setContents:(__bridge id)imageRef];
    CFRelease(imageRef);
    
    CGImageRef imageRef2 = CGImageCreateWithImageInRect([image CGImage], CGRectMake(image.size.width*image.scale/2, 0, image.size.width*image.scale/2, image.size.height*image.scale));
    [_rightView.layer setContents:(__bridge id)imageRef2];
    CFRelease(imageRef2);
}

- (void)setContent:(UIView *)contentView
{
    [contentView setFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    [_contentView addSubview:contentView];
    [self drawScreenshotOnFolds];
}


- (void)drawScreenshotOnFolds
{
    UIImage *image = [_contentView screenshot];
    [self setImage:image];
}

- (void)showFolds:(BOOL)show
{
    [_leftView setHidden:!show];
    [_rightView setHidden:!show];
}

#pragma mark states

- (void)foldDidOpened
{
    //NSLog(@"opened");
    [_contentView setHidden:NO];
    [self showFolds:NO];
}

- (void)foldDidClosed
{
    //NSLog(@"closed");
    [_contentView setHidden:NO];
    [self showFolds:YES];
}

- (void)foldWillOpen
{
    //NSLog(@"transition - opening");
    //[self drawScreenshotOnFolds];
    [_contentView setHidden:YES];
    [self showFolds:YES];
}

- (void)foldWillClose
{
    //NSLog(@"transition - closing");
    [self drawScreenshotOnFolds];
    [_contentView setHidden:YES];
    [self showFolds:YES];
}
@end
