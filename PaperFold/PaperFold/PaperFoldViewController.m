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
CGFloat const kLeftViewWidth = 100;

@synthesize rightView = _rightView;
@synthesize rightView1 = _rightView1;
@synthesize rightView2 = _rightView2;
@synthesize rightViewSecond = _rightViewSecond;
@synthesize rightViewSecond1 = _rightViewSecond1;
@synthesize rightViewSecond2 = _rightViewSecond2;
@synthesize rightViewThird = _rightViewThird;
@synthesize rightViewThird1 = _rightViewThird1;
@synthesize rightViewThird2 = _rightViewThird2;

CGFloat const kRightPart1 = 0.5;
CGFloat const kRightPart2 = 0.35;
CGFloat const kRightPart3 = 0.15;
CGFloat const kRightViewWidth = 80;

- (id)init
{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:_contentView];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        //[_contentView setAlpha:0.5];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onContentViewPanned:)];
        [_contentView addGestureRecognizer:panGestureRecognizer];

        [self.view setBackgroundColor:[UIColor darkGrayColor]];
        
        _leftFoldView = [[FoldView alloc] initWithFrame:CGRectMake(0,0,kLeftViewWidth,[self.view bounds].size.height)];
        [self.view insertSubview:_leftFoldView belowSubview:_contentView];
        
        _rightView = [[UIView alloc] initWithFrame:CGRectMake([self.view bounds].size.width,0,kRightViewWidth,[self.view bounds].size.height)];
        [_rightView setBackgroundColor:[UIColor darkGrayColor]];
        [_contentView addSubview:_rightView];
        CATransform3D transform2 = CATransform3DIdentity;
        transform2.m34 = -1/500.0;
        [_rightView.layer setSublayerTransform:transform2];
        
        _rightView1 = [[FacingView alloc] initWithFrame:CGRectMake(-kRightViewWidth/4,0,kRightViewWidth/2,[self.view bounds].size.height)];
        [_rightView1 setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightView1.layer setAnchorPoint:CGPointMake(0.0, 0.5)];
        [_rightView addSubview:_rightView1];
        [_rightView1.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.05],[UIColor colorWithWhite:0 alpha:0.2], nil]];
        
        _rightView2 = [[FacingView alloc] initWithFrame:CGRectMake(-kRightViewWidth/4,0,kRightViewWidth/2,[self.view bounds].size.height)];
        [_rightView2 setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightView2.layer setAnchorPoint:CGPointMake(1.0, 0.5)];
        [_rightView addSubview:_rightView2];
        [_rightView2.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.2],[UIColor colorWithWhite:0 alpha:0.05], nil]];

        
        _rightViewSecond = [[UIView alloc] initWithFrame:CGRectMake([self.view bounds].size.width+kRightViewWidth,0,kRightViewWidth,[self.view bounds].size.height)];
        [_rightViewSecond setBackgroundColor:[UIColor darkGrayColor]];
        [_contentView addSubview:_rightViewSecond];
        CATransform3D transform3 = CATransform3DIdentity;
        transform3.m34 = -1/500.0;
        [_rightViewSecond.layer setSublayerTransform:transform3];
        
        _rightViewSecond1 = [[FacingView alloc] initWithFrame:CGRectMake(-kRightViewWidth/4,0,kRightViewWidth/2,[self.view bounds].size.height)];
        [_rightViewSecond1 setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightViewSecond1.layer setAnchorPoint:CGPointMake(0.0, 0.5)];
        [_rightViewSecond addSubview:_rightViewSecond1];
        [_rightViewSecond1.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.05],[UIColor colorWithWhite:0 alpha:0.2], nil]];

        
        _rightViewSecond2 = [[FacingView alloc] initWithFrame:CGRectMake(-kRightViewWidth/4,0,kRightViewWidth/2,[self.view bounds].size.height)];
        [_rightViewSecond2 setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightViewSecond2.layer setAnchorPoint:CGPointMake(1.0, 0.5)];
        [_rightViewSecond addSubview:_rightViewSecond2];
        [_rightViewSecond2.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.2],[UIColor colorWithWhite:0 alpha:0.05], nil]];
        
        _rightViewThird = [[UIView alloc] initWithFrame:CGRectMake([self.view bounds].size.width+kRightViewWidth*2,0,kRightViewWidth,[self.view bounds].size.height)];
        [_rightViewThird setBackgroundColor:[UIColor darkGrayColor]];
        [_contentView addSubview:_rightViewThird];
        CATransform3D transform4 = CATransform3DIdentity;
        transform4.m34 = -1/500.0;
        [_rightViewThird.layer setSublayerTransform:transform4];
        
        _rightViewThird1 = [[FacingView alloc] initWithFrame:CGRectMake(-kRightViewWidth/4,0,kRightViewWidth/2,[self.view bounds].size.height)];
        [_rightViewThird1 setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightViewThird1.layer setAnchorPoint:CGPointMake(0.0, 0.5)];
        [_rightViewThird addSubview:_rightViewThird1];
        [_rightViewThird1.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.05],[UIColor colorWithWhite:0 alpha:0.2], nil]];

        
        _rightViewThird2 = [[FacingView alloc] initWithFrame:CGRectMake(-kRightViewWidth/4,0,kRightViewWidth/2,[self.view bounds].size.height)];
        [_rightViewThird2 setBackgroundColor:[UIColor colorWithWhite:0.99 alpha:1]];
        [_rightViewThird2.layer setAnchorPoint:CGPointMake(1.0, 0.5)];
        [_rightViewThird addSubview:_rightViewThird2];
        [_rightViewThird2.shadowView setColorArrays:[NSArray arrayWithObjects:[UIColor colorWithWhite:0 alpha:0.2],[UIColor colorWithWhite:0 alpha:0.05], nil]];
        
        [_rightViewSecond2.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, 1, 0)];
        [_rightView2.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, 1, 0)];
        [_rightViewThird2.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, 1, 0)];
        [_rightViewSecond1.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, -1, 0)];
        [_rightView1.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, -1, 0)];
        [_rightViewThird1.layer setTransform:CATransform3DMakeRotation((M_PI / 2), 0, -1, 0)];
        
        //[_contentView.layer.presentationLayer addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    NSLog(@"changed %@", object);
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
        /*
        [UIView animateWithDuration:0.3 animations:^{
           [_contentView setTransform:CGAffineTransformMakeTranslation(0, 0)]; 
        }];*/
        
        
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
        
        CGFloat fraction = x / kLeftViewWidth;
        if (fraction < 0) fraction = 0;
        if (fraction > 1) fraction = 1;
        [_leftFoldView unfoldViewToFraction:fraction];
    }
    else if (x<0)
    {
        float x1 = x;
        if (x1<-kRightViewWidth*3)
        {
            x1 = -kRightViewWidth*3;
        }
        [_contentView setTransform:CGAffineTransformMakeTranslation(x1, 0)];
        
        // first fold
        float x2 = x;
        if (x2<-1*(kRightViewWidth+40))
        {
            x2 = -1*(kRightViewWidth+40);
        }
        CGFloat fraction = x2 /(-1*(kRightViewWidth+40));
       
        if (fraction < 0) fraction = 0;
        if (fraction > 1) fraction = 1;
        [self unfoldRightViewToFraction:fraction];
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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

- (void)unfoldRightViewToFraction:(CGFloat)fraction
{
    float delta = asinf(fraction);
    
    [_rightView1.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta, 0, 1, 0)];
    CATransform3D transform1 = CATransform3DMakeTranslation(2*_rightView1.frame.size.width, 0, 0);
    CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - delta, 0, -1, 0);
    CATransform3D transform = CATransform3DConcat(transform2, transform1);
    [_rightView2.layer setTransform:transform];
    
    [_rightView1.shadowView setAlpha:1-fraction];
    [_rightView2.shadowView setAlpha:1-fraction];
    
    [_rightViewSecond setFrame:CGRectMake([self.view bounds].size.width+2*_rightView1.frame.size.width,0,_rightViewSecond.frame.size.width,_rightViewSecond.frame.size.height)];
    
    float x = _contentView.frame.origin.x+2*_rightView1.frame.size.width;
    CGFloat fraction2 = (-1*x)/(kRightViewWidth+40);
   
    if (fraction2 < 0) fraction2 = 0;
    if (fraction2 > 1) fraction2 = 1;
    [self unfoldRightViewSecondToFraction:fraction2];
}

- (void)unfoldRightViewSecondToFraction:(CGFloat)fraction
{
    float delta2 = asinf(fraction);
    [_rightViewSecond1.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta2, 0, 1, 0)];
    CATransform3D transform3 = CATransform3DMakeTranslation(2*_rightViewSecond1.frame.size.width, 0, 0);
    CATransform3D transform4 = CATransform3DMakeRotation((M_PI / 2) - delta2, 0, -1, 0);
    CATransform3D transform5 = CATransform3DConcat(transform4, transform3);
    [_rightViewSecond2.layer setTransform:transform5];
    
    [_rightViewSecond1.shadowView setAlpha:1-fraction];
    [_rightViewSecond2.shadowView setAlpha:1-fraction];
    
    [_rightViewThird setFrame:CGRectMake([self.view bounds].size.width+2*_rightView1.frame.size.width+2*_rightViewSecond1.frame.size.width,0,_rightViewThird.frame.size.width,_rightViewThird.frame.size.height)];
    
    float x = _contentView.frame.origin.x+2*_rightView1.frame.size.width+2*_rightViewSecond1.frame.size.width;
    CGFloat fraction2 = (-1*x)/(kRightViewWidth);

    if (fraction2 < 0) fraction2 = 0;
    if (fraction2 > 1) fraction2 = 1;
    [self unfoldRightViewThirdToFraction:fraction2];
}

- (void)unfoldRightViewThirdToFraction:(CGFloat)fraction
{
    float delta2 = asinf(fraction);
    [_rightViewThird1.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - delta2, 0, 1, 0)];
    CATransform3D transform3 = CATransform3DMakeTranslation(2*_rightViewThird1.frame.size.width, 0, 0);
    CATransform3D transform4 = CATransform3DMakeRotation((M_PI / 2) - delta2, 0, -1, 0);
    CATransform3D transform5 = CATransform3DConcat(transform4, transform3);
    [_rightViewThird2.layer setTransform:transform5];
    
    [_rightViewThird1.shadowView setAlpha:1-fraction];
    [_rightViewThird2.shadowView setAlpha:1-fraction];
}

@end
