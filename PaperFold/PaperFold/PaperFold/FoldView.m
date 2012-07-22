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
        
        
        
        // foldview consists of leftView and rightView, and a content view
        // set shadow direction of leftView and rightView such that the shadow falls on the fold in the middle
        
        // content view holds a subview which is the actual displayed content
        // contentView is required as a wrapper of the original content because it is better to take a screenshot of the wrapper view layer
        // taking a screenshot of a tableview layer directly for example, may end up with blank view because of recycled cells
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
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
        [_rightView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.9],[UIColor colorWithWhite:0 alpha:0.55], nil]];
        
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
	[self.leftView.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta, 0, 1, 0)];

    // rotate rightView on the right edge of the view
    // translate rotated view to the left to join to the edge of the leftView
    CATransform3D transform1 = CATransform3DMakeTranslation(2*self.leftView.frame.size.width, 0, 0);
    CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - delta, 0, -1, 0);
    CATransform3D transform = CATransform3DConcat(transform2, transform1);
    [self.rightView.layer setTransform:transform];

    // fade in shadow when folding
    // fade out shadow when unfolding
    [self.leftView.shadowView setAlpha:1-fraction];
    [self.rightView.shadowView setAlpha:1-fraction];
}

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset
{
    CGFloat fraction = offset / self.frame.size.width;
    if (fraction < 0) fraction = 0;
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
    
    CGFloat fraction = offset / self.frame.size.width;
    if (fraction < 0) fraction = 0;
    if (fraction > 1) fraction = 1;
    
    [self unfoldViewToFraction:fraction];
}

- (void)setImage:(UIImage*)image
{
    // split the image into 2, one for each folds
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, image.size.width*image.scale/2, image.size.height*image.scale));
    [self.leftView.layer setContents:(__bridge id)imageRef];
    CFRelease(imageRef);
    
    CGImageRef imageRef2 = CGImageCreateWithImageInRect([image CGImage], CGRectMake(image.size.width*image.scale/2, 0, image.size.width*image.scale/2, image.size.height*image.scale));
    [self.rightView.layer setContents:(__bridge id)imageRef2];
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
    [self.leftView setHidden:!show];
    [self.rightView setHidden:!show];
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
