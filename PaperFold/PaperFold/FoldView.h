//
//  FoldView.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacingView.h"

typedef enum
{
    FoldStateClosed = 0,
    FoldStateOpened = 1,
    FoldStateTransition = 2
} FoldState;

@interface FoldView : UIView

// each folderView consists of 2 facing views: leftView and rightView
@property (strong) FacingView *leftView, *rightView;
// indicate whether the fold is open or closed
@property (assign) FoldState state;

// unfold the 2 facing views using a fraction 0 to 1
// 0 when it's completely folded
// 1 when it's completely unfolded
// fraction is calculated based on parent offset
- (void)unfoldViewToFraction:(CGFloat)fraction;

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset;

// unfold the 2 facing views based on parent offset
- (void)unfoldWithParentOffset:(float)offset;

- (void)setImage:(UIImage*)image;

#pragma mark states
- (void)foldDidOpened;
- (void)foldDidClosed;
- (void)foldWillOpen;
- (void)foldWillClose;

@end
