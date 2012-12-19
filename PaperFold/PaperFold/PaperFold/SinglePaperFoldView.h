//
//  SinglePaperFoldView.h
//  PaperFold
//
//  Created by Wang Hailong on 12-12-19.
//  Copyright (c) 2012年 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiFoldView.h"

@interface SinglePaperFoldView : UIView

- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection folds:(int)folds pullFactor:(float)factor;

- (void)unfoldWithParentOffset:(float)offset;
- (void)unfoldViewToFraction:(CGFloat)fraction;

- (void)setContent:(UIView *)contentView;

- (void)unfoldPaper:(BOOL)unfold Animation:(BOOL)animation;

@end
