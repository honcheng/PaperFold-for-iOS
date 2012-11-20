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

@class MKMapView;
#import <UIKit/UIKit.h>
#import "FoldView.h"

@protocol MultiFoldViewDelegate <NSObject>
- (CGFloat)displacementOfMultiFoldView:(id)multiFoldView;
@end

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
// take screenshot just before unfolding
// this is only necessary for mapview, not for the rest of the views
@property (nonatomic, readonly) BOOL shouldTakeScreenshotBeforeUnfolding;

@property (nonatomic, strong) UIView *contentViewHolder;

@property (nonatomic, assign) id<MultiFoldViewDelegate> delegate;

// init with the number of folds and pull factor

// defaults to horizontal fold
- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)pullFactor;
- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection folds:(int)folds pullFactor:(float)pullFactor;

// set the content of the view
- (void)setContent:(UIView *)contentView;
// get screenshot of content to overlay in folds
- (void)drawScreenshotOnFolds;
- (void)setScreenshotImage:(UIImage*)image;

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
- (void)unfoldView:(FoldView*)foldView toFraction:(CGFloat)fraction withOffset:(float)offset;

// show/hide all folds
- (void)showFolds:(BOOL)show;

// unfold without animation
// temporary method
- (void)unfoldWithoutAnimation;

#pragma mark states
// states of folds
- (void)foldDidOpened;
- (void)foldDidClosed;
- (void)foldWillOpen;
- (void)foldWillClose;

@end
