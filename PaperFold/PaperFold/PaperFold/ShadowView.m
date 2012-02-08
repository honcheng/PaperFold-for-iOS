//
//  ShadowView.m
//  SGBusArrivals
//
//  Created by honcheng on 2/12/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import "ShadowView.h"


@implementation ShadowView
@synthesize _colorsArray, gradient;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.gradient = [CAGradientLayer layer];
		[self.gradient setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self.gradient setStartPoint:CGPointMake(0, 0)];
        [self.gradient setEndPoint:CGPointMake(1, 0)];
		[self.layer insertSublayer:self.gradient atIndex:0];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setColorArrays:(NSMutableArray*)colors
{
	//[self._colorsArray release];
	self._colorsArray = [NSMutableArray new];
	for (UIColor *color in colors)
	{
		[self._colorsArray addObject:(id)[color CGColor]];
	}
	
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
	if ([self._colorsArray count]>0)
	{
		[self.gradient setColors:self._colorsArray];
	}
}

- (void)dealloc {
	//[self.gradient release];
	//[self._colorsArray release];
    //[super dealloc];
}

@end
