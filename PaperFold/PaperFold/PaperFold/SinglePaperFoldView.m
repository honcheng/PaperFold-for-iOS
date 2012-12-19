//
//  SinglePaperFoldView.m
//  PaperFold
//
//  Created by Wang Hailong on 12-12-19.
//  Copyright (c) 2012年 honcheng@gmail.com. All rights reserved.
//

#import "SinglePaperFoldView.h"

@interface SinglePaperFoldView ()

@property (nonatomic, strong) MultiFoldView *multiFoldView;
@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation SinglePaperFoldView

- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection folds:(int)folds pullFactor:(float)factor {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _multiFoldView = [[MultiFoldView alloc] initWithFrame:self.bounds foldDirection:foldDirection folds:folds pullFactor:factor];
        [self addSubview:_multiFoldView];
    }
    return self;
}

- (void)setContent:(UIView *)contentView {
    [self.multiFoldView setContent:contentView];
}

#pragma mark Unfold & fold
- (void)unfoldWithParentOffset:(float)offset {
    [self.multiFoldView unfoldWithParentOffset:offset];
}

- (void)unfoldViewToFraction:(CGFloat)fraction {
    [self.multiFoldView unfoldViewToFraction:fraction];
}

- (void)unfoldWithoutAnimation {
    [self.multiFoldView unfoldWithoutAnimation];
}

- (void)unfoldPaper:(BOOL)unfold Animation:(BOOL)animation {
    if (animation) {
        if (unfold) {
            [self.animationTimer invalidate];
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldView:) userInfo:nil repeats:YES];
        }
        else {
            [self.animationTimer invalidate];
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(restoreView:) userInfo:nil repeats:YES];
        }
    }
    else {
        if (unfold) {
            [self unfoldWithoutAnimation];
        }
        else {
            [self.multiFoldView unfoldViewToFraction:0];
        }
    }
}

- (void)unfoldView:(NSTimer*)timer {
    if (self.multiFoldView.foldDirection == FoldDirectionHorizontalLeftToRight || self.multiFoldView.foldDirection == FoldDirectionHorizontalRightToLeft) {
        float x = self.multiFoldView.offset + (self.multiFoldView.frame.size.width - self.multiFoldView.offset) / 8;
        if (x > self.multiFoldView.frame.size.width - 3) {
            [timer invalidate];
            x = self.multiFoldView.frame.size.width;
        }
        [self.multiFoldView unfoldWithParentOffset:x];
        if (self.multiFoldView.foldDirection == FoldDirectionHorizontalRightToLeft) {
            [self.multiFoldView setTransform:CGAffineTransformMakeTranslation(self.multiFoldView.frame.size.width - self.multiFoldView.offset, 0)];
        }
    }
    else if (self.multiFoldView.foldDirection == FoldDirectionVerticalBottomToTop || self.multiFoldView.foldDirection == FoldDirectionVerticalTopToBottom) {
        float y = self.multiFoldView.offset + (self.multiFoldView.frame.size.height - self.multiFoldView.offset) / 8;
        if (y > self.multiFoldView.frame.size.height - 3) {
            [timer invalidate];
            y = self.multiFoldView.frame.size.height;
        }
        [self.multiFoldView unfoldWithParentOffset:y];
        if (self.multiFoldView.foldDirection == FoldDirectionVerticalTopToBottom) {
            [self.multiFoldView setTransform:CGAffineTransformMakeTranslation(0, - (self.multiFoldView.frame.size.height - self.multiFoldView.offset))];
        }
    }
}

- (void)restoreView:(NSTimer *)timer {
    if (self.multiFoldView.foldDirection == FoldDirectionHorizontalLeftToRight || self.multiFoldView.foldDirection == FoldDirectionHorizontalRightToLeft) {
        float x = self.multiFoldView.offset - self.multiFoldView.offset / 8;
        if (x < 3) {
            [timer invalidate];
            x = 0;
        }
        [self.multiFoldView unfoldWithParentOffset:x];
        if (self.multiFoldView.foldDirection == FoldDirectionHorizontalRightToLeft) {
            [self.multiFoldView setTransform:CGAffineTransformMakeTranslation(self.multiFoldView.frame.size.width - self.multiFoldView.offset, 0)];
        }
    }
    else if (self.multiFoldView.foldDirection == FoldDirectionVerticalBottomToTop || self.multiFoldView.foldDirection == FoldDirectionVerticalTopToBottom) {
        float y = self.multiFoldView.offset - self.multiFoldView.offset / 8;
        if (y <  3) {
            [timer invalidate];
            y = 0;
        }
        [self.multiFoldView unfoldWithParentOffset:y];
        if (self.multiFoldView.foldDirection == FoldDirectionVerticalTopToBottom) {
            [self.multiFoldView setTransform:CGAffineTransformMakeTranslation(0, - (self.multiFoldView.frame.size.height - self.multiFoldView.offset))];
        }
    }
}

- (FoldState)foldState {
    return self.multiFoldView.state;
}

@end
