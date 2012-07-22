//
//  PaperFoldViewController.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

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

@interface PaperFoldViewController : UIViewController

// main content view
@property (strong, nonatomic) TouchThroughUIView *contentView;
// timer to animate folds after gesture ended
// manual animation with NSTimer is required to sync the offset of the contentView, with the folding of views
@property (strong, nonatomic) NSTimer *animationTimer;
// the fold view on the left
@property (strong, nonatomic) FoldView *leftFoldView;
// the multiple fold view on the right
@property (strong, nonatomic) MultiFoldView *rightFoldView;
// state of the current fold
@property (assign, nonatomic) PaperFoldState state;

// animate folding and unfolding when sent the offset of contentView
// offset are either sent from pan gesture recognizer, or manual animation done with NSTimer after gesture ended
- (void)animateWhenPanned:(CGPoint)point;

// set the right fold content view
// and the right fold container view
// with the number of folds and pull factor
- (void)setRightFoldContentView:(UIView*)view rightViewFoldCount:(int)rightViewFoldCount rightViewPullFactor:(float)rightViewPullFactor;

// set the left fold content view
// and set the left fold container view frame
- (void)setLeftFoldContentView:(UIView*)view;

@end
