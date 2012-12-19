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
        _multiFoldView = [[MultiFoldView alloc] initWithFrame:frame foldDirection:foldDirection folds:folds pullFactor:factor];
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
    if (self.multiFoldView.foldDirection == FoldDirectionHorizontalLeftToRight) {
        float x = self.multiFoldView.offset + (self.multiFoldView.frame.size.width - self.multiFoldView.offset) / 8;
        if (x > self.multiFoldView.frame.size.width - 3) {
            [timer invalidate];
            x = self.multiFoldView.frame.size.width;
        }
        [self.multiFoldView unfoldWithParentOffset:x];
    }
    else if (self.multiFoldView.foldDirection == FoldDirectionHorizontalRightToLeft) {
        float x = self.multiFoldView.offset + (self.multiFoldView.frame.size.width - self.multiFoldView.offset) / 8;
        if (x > self.multiFoldView.frame.size.width - 3) {
            [timer invalidate];
            x = self.multiFoldView.frame.size.width;
        }
        [self.multiFoldView unfoldWithParentOffset:x];
        [self.multiFoldView setTransform:CGAffineTransformMakeTranslation(self.multiFoldView.frame.size.width - self.multiFoldView.offset, 0)];
    }
}

- (void)restoreView:(NSTimer *)timer {
    
}

@end
