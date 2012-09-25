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


#import <UIKit/UIKit.h>
#import "FacingView.h"
#import "FoldView.h"

@interface FoldView : UIView

// each folderView consists of 2 facing views: leftView and rightView
@property (nonatomic) FacingView *leftView, *rightView;
// or topView and bottomView
@property (nonatomic) FacingView *topView, *bottomView;


// indicate whether the fold is open or closed
@property (nonatomic, assign) FoldState state;
// wrapper of the visible view
@property (nonatomic) UIView *contentView;
@property (nonatomic, assign) FoldDirection foldDirection;
// optimized screenshot follows the scale of the screen
// non-optimized is always the non-retina image
@property (nonatomic, assign) BOOL useOptimizedScreenshot;


- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection;

// unfold the 2 facing views using a fraction 0 to 1
// 0 when it's completely folded
// 1 when it's completely unfolded
// fraction is calculated based on parent offset
- (void)unfoldViewToFraction:(CGFloat)fraction;

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset;

// unfold the 2 facing views based on parent offset
- (void)unfoldWithParentOffset:(float)offset;

// set the visible view, to be added as a subview
- (void)setContent:(UIView *)contentView;

// take screenshot of the wrapper view layer, containing the visible view
- (void)drawScreenshotOnFolds;

// show/hide folds
- (void)showFolds:(BOOL)show;

// set the screenshot overlay on the 2 folds
// image gets spliced into 2, one for each folds
- (void)setImage:(UIImage*)image;

#pragma mark states
- (void)foldDidOpened;
- (void)foldDidClosed;
- (void)foldWillOpen;
- (void)foldWillClose;

@end
