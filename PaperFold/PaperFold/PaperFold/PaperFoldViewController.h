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

typedef enum
{
    PaperFoldStateDefault = 0,
    PaperFoldStateLeftUnfolded = 1,
    PaperFoldStateRightUnfolded = 2,
    PaperFoldStateTransition = 3
} PaperFoldState;

@protocol PaperFoldViewControllerDelegate <NSObject>
// callback when paper fold transition state changes
// does not callback when action is cancelled
- (void)paperFoldViewController:(id)paperFoldViewController didTransitionToState:(PaperFoldState)paperFoldState;
@end

@interface PaperFoldViewController : UIViewController

// main content view
@property (nonatomic) TouchThroughUIView *contentView;
// timer to animate folds after gesture ended
// manual animation with NSTimer is required to sync the offset of the contentView, with the folding of views
@property (nonatomic) NSTimer *animationTimer;
// the fold view on the left
@property (nonatomic) FoldView *leftFoldView;
// the multiple fold view on the right
@property (nonatomic) MultiFoldView *rightFoldView;
// state of the current fold
@property (nonatomic, assign) PaperFoldState state, lastState;
// enable and disable dragging
@property (nonatomic, assign) BOOL enableLeftFoldDragging, enableRightFoldDragging;
@property (nonatomic, assign) id<PaperFoldViewControllerDelegate> delegate;

// animate folding and unfolding when sent the offset of contentView
// offset are either sent from pan gesture recognizer, or manual animation done with NSTimer after gesture ended
- (void)animateWithContentOffset:(CGPoint)point panned:(BOOL)panned;

// set the right fold content view
// and the right fold container view
// with the number of folds and pull factor
- (void)setRightFoldContentView:(UIView*)view rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor;

// set the left fold content view
// and set the left fold container view frame
- (void)setLeftFoldContentView:(UIView*)view;

// unfold the left and right view
- (void)setPaperFoldState:(PaperFoldState)state;

// deprecate methods
// use setPaperFoldState: instead
- (void)unfoldLeftView __attribute__((deprecated));
- (void)unfoldRightView __attribute__((deprecated));
- (void)restoreToCenter __attribute__((deprecated));

@end
