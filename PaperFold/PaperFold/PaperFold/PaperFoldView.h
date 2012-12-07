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
#import "MultiFoldView.h"
#import "TouchThroughUIView.h"

typedef void (^CompletionBlock)();

@protocol PaperFoldViewDelegate <NSObject>
@optional
// callback when paper fold transition state changes
// does not callback when action is cancelled
- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState;
// callback when paper fold view is offset
- (void)paperFoldView:(id)paperFoldView viewDidOffset:(CGPoint)offset;
@end

@interface PaperFoldView : UIView <MultiFoldViewDelegate, UIGestureRecognizerDelegate>

// main content view
@property (nonatomic, strong) TouchThroughUIView *contentView;
// timer to animate folds after gesture ended
// manual animation with NSTimer is required to sync the offset of the contentView, with the folding of views
@property (nonatomic, strong) NSTimer *animationTimer;
// the fold view on the left and bottom
@property (nonatomic, strong) FoldView *bottomFoldView;
// the fold view on the left
@property (nonatomic, strong) MultiFoldView *leftFoldView;
// the multiple fold view on the right
@property (nonatomic, strong) MultiFoldView *rightFoldView;
// the multiple fold view on the top
@property (nonatomic, strong) MultiFoldView *topFoldView;
// state of the current fold
@property (nonatomic, assign) PaperFoldState state, lastState;
// enable and disable dragging
@property (nonatomic, assign) BOOL enableLeftFoldDragging, enableRightFoldDragging, enableTopFoldDragging, enableBottomFoldDragging;
@property (nonatomic, assign) BOOL enableHorizontalEdgeDragging;
// indicate if the fold was triggered by finger panning, or set state
@property (nonatomic, assign) BOOL isAutomatedFolding;
@property (nonatomic, assign) id<PaperFoldViewDelegate> delegate;
// the initial panning direction
@property (nonatomic, assign) PaperFoldInitialPanDirection paperFoldInitialPanDirection;
// optimized screenshot follows the scale of the screen
// non-optimized is always the non-retina image
@property (nonatomic, assign) BOOL useOptimizedScreenshot;
// restrict the dragging gesture recogniser to a certain UIRect of this view. Useful to restrict
// dragging to, say, a navigation bar.
@property (nonatomic, assign) CGRect restrictedDraggingRect;
// divider lines
// these are exposed so that it is possible to hide the lines
// especially when views have rounded corners
@property (nonatomic, weak) UIView *leftDividerLine;
@property (nonatomic, weak) UIView *rightDividerLine;
@property (nonatomic, weak) UIView *topDividerLine;
@property (nonatomic, weak) UIView *bottomDividerLine;

// animate folding and unfolding when sent the offset of contentView
// offset are either sent from pan gesture recognizer, or manual animation done with NSTimer after gesture ended
- (void)animateWithContentOffset:(CGPoint)point panned:(BOOL)panned;

// set the right fold content view
// and the right fold container view
// with the number of folds and pull factor
- (void)setRightFoldContentView:(UIView*)view foldCount:(int)rightViewFoldCount pullFactor:(float)rightViewPullFactor;

// set the top fold content view
// and the top fold container view
// with the number of folds and pull factor
- (void)setTopFoldContentView:(UIView*)view topViewFoldCount:(int)topViewFoldCount topViewPullFactor:(float)topViewPullFactor;

// set the left fold content view
// and set the left fold container view frame
- (void)setLeftFoldContentView:(UIView*)view foldCount:(int)leftViewFoldCount pullFactor:(float)leftViewPullFactor;

// set the bottom fold content view
// and set the bottom fold container view frame
- (void)setBottomFoldContentView:(UIView*)view;

- (void)setCenterContentView:(UIView*)view;

// unfold the left and right view
- (void)setPaperFoldState:(PaperFoldState)state;
- (void)setPaperFoldState:(PaperFoldState)state animated:(BOOL)animated;
- (void)setPaperFoldState:(PaperFoldState)state
								 animated:(BOOL)animated
							 completion:(CompletionBlock)completion;

// deprecate methods
// use setPaperFoldState: instead
- (void)unfoldLeftView __attribute__((deprecated));
- (void)unfoldRightView __attribute__((deprecated));
- (void)restoreToCenter __attribute__((deprecated));
// set fold views
- (void)setLeftFoldContentView:(UIView*)view __attribute__((deprecated));
- (void)setRightFoldContentView:(UIView*)view rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor __attribute__((deprecated));;

@end
