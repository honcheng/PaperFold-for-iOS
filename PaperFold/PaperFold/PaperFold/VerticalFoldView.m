//
//  VerticalFoldView.m
//  PaperFold
//
//  Created by honcheng on 25/8/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "VerticalFoldView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Screenshot.h"

@implementation VerticalFoldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // foldview consists of leftView and rightView, and a content view
        // set shadow direction of leftView and rightView such that the shadow falls on the fold in the middle
        
        // content view holds a subview which is the actual displayed content
        // contentView is required as a wrapper of the original content because it is better to take a screenshot of the wrapper view layer
        // taking a screenshot of a tableview layer directly for example, may end up with blank view because of recycled cells
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
        // set anchor point of the leftView to the left edge
        _bottomView = [[FacingView alloc] initWithFrame:CGRectMake(0,3*frame.size.height/4,frame.size.width,frame.size.height/2)];
        [_bottomView setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_bottomView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
        [self addSubview:_bottomView];
        [_bottomView.shadowView.gradient setStartPoint:CGPointMake(0, 0)];
        [_bottomView.shadowView.gradient setEndPoint:CGPointMake(0, 1)];
        [_bottomView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.05],[UIColor colorWithWhite:0 alpha:0.6], nil]];
        
        // set anchor point of the rightView to the right edge
        _topView = [[FacingView alloc] initWithFrame:CGRectMake(0,3*frame.size.height/4,frame.size.width,frame.size.height/2)];
        [_topView setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_topView.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
        [self addSubview:_topView];
        [_topView.shadowView.gradient setStartPoint:CGPointMake(0, 0)];
        [_topView.shadowView.gradient setEndPoint:CGPointMake(0, 1)];
        [_topView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.9],[UIColor colorWithWhite:0 alpha:0.55], nil]];
        
        // set perspective of the transformation
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.0;
        [self.layer setSublayerTransform:transform];
        
        // make sure the views are closed properly when initialized
        [_bottomView.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 1, 0, 0)];
        [_topView.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 1, 0, 0)];
        
        [self setAutoresizesSubviews:YES];
        [_contentView setAutoresizesSubviews:YES];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

- (void)unfoldViewToFraction:(CGFloat)fraction
{
    float delta = asinf(fraction);
    
    // rotate bottomView on the left edge of the view
	[self.bottomView.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta, 1, 0, 0)];
    
    // rotate topView on the right edge of the view
    // translate rotated view to the bottom to join to the edge of the bottomView
    CATransform3D transform1 = CATransform3DMakeTranslation(0, -2*self.bottomView.frame.size.height, 0);
    CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - delta, -1, 0, 0);
    CATransform3D transform = CATransform3DConcat(transform2, transform1);
    [self.topView.layer setTransform:transform];
    
    // fade in shadow when folding
    // fade out shadow when unfolding
    [self.bottomView.shadowView setAlpha:1-fraction];
    [self.topView.shadowView setAlpha:1-fraction];
}

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset
{
    CGFloat fraction = offset / self.frame.size.height;
    if (fraction < 0) fraction = -1*fraction;
    if (fraction > 1) fraction = 1;
    
    if (self.state==FoldStateClosed && fraction>0)
    {
        self.state = FoldStateTransition;
        [self foldWillOpen];
    }
    else if (self.state==FoldStateOpened && fraction<1)
    {
        self.state = FoldStateTransition;
        [self foldWillClose];
        
    }
    else if (self.state==FoldStateTransition)
    {
        if (fraction==0)
        {
            self.state = FoldStateClosed;
            [self foldDidClosed];
        }
        else if (fraction==1)
        {
            self.state = FoldStateOpened;
            [self foldDidOpened];
        }
    }
}

- (void)unfoldWithParentOffset:(float)offset
{
    [self calculateFoldStateFromOffset:offset];
    
    CGFloat fraction = offset / self.frame.size.height;
 
    if (fraction < 0) fraction = -1*fraction;
    if (fraction > 1) fraction = 1;
    [self unfoldViewToFraction:fraction];
}

- (void)setImage:(UIImage*)image
{
    // split the image into 2, one for each folds
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, image.size.height*image.scale/2, image.size.width*image.scale, image.size.height*image.scale/2));
    [self.bottomView.layer setContents:(__bridge id)imageRef];
    CFRelease(imageRef);
    
    CGImageRef imageRef2 = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, image.size.width*image.scale, image.size.height*image.scale/2));
    [self.topView.layer setContents:(__bridge id)imageRef2];
    CFRelease(imageRef2);
}

- (void)setContent:(UIView *)contentView
{
    // add the actual visible view, as a subview of _contentView
    [contentView setFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    [self.contentView addSubview:contentView];
    [self drawScreenshotOnFolds];
}


- (void)drawScreenshotOnFolds
{
    UIImage *image = [self.contentView screenshot];
    [self setImage:image];
}

- (void)showFolds:(BOOL)show
{
    [self.topView setHidden:!show];
    [self.bottomView setHidden:!show];
}

#pragma mark states

- (void)foldDidOpened
{
    //NSLog(@"opened");
    [self.contentView setHidden:NO];
    [self showFolds:NO];
}

- (void)foldDidClosed
{
    //NSLog(@"closed");
    [self.contentView setHidden:NO];
    [self showFolds:YES];
}

- (void)foldWillOpen
{
    //NSLog(@"transition - opening");
    //[self drawScreenshotOnFolds];
    [self.contentView setHidden:YES];
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
