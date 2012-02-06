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

@interface PaperFoldViewController : UIViewController

// main content view
@property (strong, nonatomic) UIView *contentView;
// timer to animate folds after gesture ended
// manual animation with NSTimer is required to sync the offset of the contentView, with the folding of views
@property (strong) NSTimer *animationTimer;
// the fold view on the left
@property (strong, nonatomic) FoldView *leftFoldView;

@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) FacingView *rightView1, *rightView2;
@property (strong, nonatomic) UIView *rightViewSecond;
@property (strong, nonatomic) FacingView *rightViewSecond1, *rightViewSecond2;
@property (strong, nonatomic) UIView *rightViewThird;
@property (strong, nonatomic) FacingView *rightViewThird1, *rightViewThird2;

- (void)unfoldRightViewToFraction:(CGFloat)fraction;
- (void)unfoldRightViewSecondToFraction:(CGFloat)fraction;
- (void)unfoldRightViewThirdToFraction:(CGFloat)fraction;

// animate folding and unfolding when sent the offset of contentView
// offset are either sent from pan gesture recognizer, or manual animation done with NSTimer after gesture ended
- (void)animateWhenPanned:(CGPoint)point;

@end
