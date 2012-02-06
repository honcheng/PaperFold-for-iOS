//
//  PaperFoldViewController.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldView.h"

@interface PaperFoldViewController : UIViewController
@property (strong, nonatomic) UIView *contentView;
@property (strong) NSTimer *animationTimer;

@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) FoldView *leftView1, *leftView2;
- (void)unfoldLeftViewToFraction:(CGFloat)fraction;

@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) FoldView *rightView1, *rightView2;
@property (strong, nonatomic) UIView *rightViewSecond;
@property (strong, nonatomic) FoldView *rightViewSecond1, *rightViewSecond2;
@property (strong, nonatomic) UIView *rightViewThird;
@property (strong, nonatomic) FoldView *rightViewThird1, *rightViewThird2;

- (void)unfoldRightViewToFraction:(CGFloat)fraction;
- (void)unfoldRightViewSecondToFraction:(CGFloat)fraction;
- (void)unfoldRightViewThirdToFraction:(CGFloat)fraction;
- (void)animateWhenPanned:(CGPoint)point;

@end
