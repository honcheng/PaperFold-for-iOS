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


#import "TouchThroughUIView.h"

@implementation TouchThroughUIView

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) 
    {
        if ([[self subviews] count]>0)
        {
            for (UIView *view in [self subviews])
            {
                if ([view isKindOfClass:[MultiFoldView class]])
                {
                    return self;
                    //return [(MultiFoldView*)view contentView];
                }
            }
            return nil;
        }
        else return self;
    }
    else return view;
}*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // set any point within the bound, and on the right side of the bound, as touch area
    // it is required to set the right side of the bound as touch area because the right fold, is a subview of this view
    // the left fold is not required because it is on the same hierachy as this view, as a subview of this view's superview
    if (point.x<0) return NO;
    else return YES;
}

@end
