//
//  MultiFoldView.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldView.h"

@interface MultiFoldView : UIView
// number of folds
@property (assign) int numberOfFolds;
// fraction of the view on the right to its immediate left
// determines when the next fold on the right should open
@property (assign) float pullFactor;
// indicate whether the fold is open or closed
@property (assign) FoldState state;

@property (assign) UIView *contentView;

// init with the number of folds and pull factor
- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)pullFactor;

- (void)setContent:(UIView *)contentView;
- (void)drawScreenshotOnFolds;

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset;

// unfold the based on parent offset
- (void)unfoldWithParentOffset:(float)offset;

// unfold using a fraction 0 to 1
// 0 when it's completely folded
// 1 when it's completely unfolded
// fraction is calculated based on parent offset 
- (void)unfoldViewToFraction:(CGFloat)fraction;

// unfold foldView using fraction
- (void)unfoldView:(FoldView*)foldView toFraction:(CGFloat)fraction;

// show/hide all folds 
- (void)showFolds:(BOOL)show;

#pragma mark states
- (void)foldDidOpened;
- (void)foldDidClosed;
- (void)foldWillOpen;
- (void)foldWillClose;

@end
