//
//  FoldView.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "FacingView.h"

@implementation FacingView
@synthesize shadowView = _shadowView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // add a shadow overlay on top of the view
        _shadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_shadowView];
        [_shadowView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
