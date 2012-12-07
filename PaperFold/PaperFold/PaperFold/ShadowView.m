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


#import "ShadowView.h"


@implementation ShadowView

- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection
{
    self = [super initWithFrame:frame];
    if (self) {
        
		_gradient = [CAGradientLayer layer];
		[_gradient setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        if (foldDirection==FoldDirectionVertical)
        {
            [_gradient setStartPoint:CGPointMake(0, 1)];
            [_gradient setEndPoint:CGPointMake(0, 0)];
        }
        else
        {
            [_gradient setStartPoint:CGPointMake(0, 0)];
            [_gradient setEndPoint:CGPointMake(1, 0)];
        }
		[self.layer insertSublayer:_gradient atIndex:0];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame foldDirection:FoldDirectionHorizontalRightToLeft];
}

- (void)setColorArrays:(NSArray*)colors
{
	_colorsArray = [NSMutableArray array];
	for (UIColor *color in colors)
	{
		[self.colorsArray addObject:(id)[color CGColor]];
	}
	
	if ([self.colorsArray count]>0)
    {
        [self.gradient setColors:self.colorsArray];
    }
}

@end
