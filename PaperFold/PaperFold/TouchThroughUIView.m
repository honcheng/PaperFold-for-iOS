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
    return YES;
}

@end
