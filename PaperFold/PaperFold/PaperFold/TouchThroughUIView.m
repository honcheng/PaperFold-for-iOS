//
//  TouchThroughUIView.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 7/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "TouchThroughUIView.h"
#import "MultiFoldView.h"

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
