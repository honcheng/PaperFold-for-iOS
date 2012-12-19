//
//  MultiFoldView.h
//  PaperFold
//
//  Created by Wang Hailong on 12-12-19.
//  Copyright (c) 2012年 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldView.h"

@interface MultiFoldView : UIView
// number of folds
@property (nonatomic, assign) int numberOfFolds;
// fraction of the view on the right to its immediate left
// determines when the next fold on the right should open
@property (nonatomic, assign) float pullFactor;
// indicate whether the fold is open or closed
@property (nonatomic, assign) FoldState state;
// fold direction
@property (nonatomic, assign) FoldDirection foldDirection;
// optimized screenshot follows the scale of the screen
// non-optimized is always the non-retina image
@property (nonatomic, assign) BOOL useOptimizedScreenshot;

@property (nonatomic, strong) UIView *contentViewHolder;

// init with the number of folds and pull factor

// defaults to horizontal fold
- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)pullFactor;
- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection folds:(int)folds pullFactor:(float)pullFactor;

// set the content of the view
- (void)setContent:(UIView *)contentView;
- (void)setScreenshotImage:(UIImage*)image;

// unfold the based on parent offset
// offset MUST BE a positive number
- (void)unfoldWithParentOffset:(float)offset;

// unfold using a fraction 0 to 1
// 0 when it's completely folded
// 1 when it's completely unfolded
// fraction is calculated based on parent offset
- (void)unfoldViewToFraction:(CGFloat)fraction;

// show/hide all folds
- (void)showFolds:(BOOL)show;

// unfold without animation
// temporary method
- (void)unfoldWithoutAnimation;

@end
