//
//  FoldView.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "FoldView.h"

@implementation FoldView
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // foldview consists of leftView and rightView
        // set shadow direction of leftView and rightView such that the shadow falls on the fold in the middle
        
        // set anchor point of the leftView to the left edge
        _leftView = [[FacingView alloc] initWithFrame:CGRectMake(-1*frame.size.width/4,0,frame.size.width/2,frame.size.height)];
        [_leftView setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_leftView.layer setAnchorPoint:CGPointMake(0.0, 0.5)];
        [self addSubview:_leftView];
        [_leftView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.05],[UIColor colorWithWhite:0 alpha:0.2], nil]];
        
        // set anchor point of the rightView to the right edge
        _rightView = [[FacingView alloc] initWithFrame:CGRectMake(-1*frame.size.width/4,0,frame.size.width/2,frame.size.height)];
        [_rightView setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightView.layer setAnchorPoint:CGPointMake(1.0, 0.5)];
        [self addSubview:_rightView];
        [_rightView.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.2],[UIColor colorWithWhite:0 alpha:0.05], nil]];
        
        // set perspective of the transformation
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/800.0;
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

- (void)unfoldWithParentOffset:(float)offset
{
    CGFloat fraction = offset / self.frame.size.width;
    if (fraction < 0) fraction = 0;
    if (fraction > 1) fraction = 1;
    [self unfoldViewToFraction:fraction];
}

@end
