//
//  ShadowView.m
//  SGBusArrivals
//
//  Created by honcheng on 2/12/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import "ShadowView.h"


@implementation ShadowView
@synthesize colorsArray = _colorsArray;
@synthesize gradient = _gradient;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		_gradient = [CAGradientLayer layer];
		[_gradient setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [_gradient setStartPoint:CGPointMake(0, 0)];
        [_gradient setEndPoint:CGPointMake(1, 0)];
		[self.layer insertSublayer:_gradient atIndex:0];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setColorArrays:(NSMutableArray*)colors
{
	_colorsArray = [NSMutableArray array];
	for (UIColor *color in colors)
	{
		[self.colorsArray addObject:(id)[color CGColor]];
	}
	
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
	if ([self.colorsArray count]>0)
	{
		[self.gradient setColors:self.colorsArray];
	}
}

@end
