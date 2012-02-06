//
//  MultiFoldView.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldView.h"

@interface MultiFoldView : UIView
@property (assign) int numberOfFolds;
@property (assign) float pullFactor;
- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)pullFactor;
- (void)unfoldViewToFraction:(CGFloat)fraction;
- (void)unfoldView:(FoldView*)foldView toFraction:(CGFloat)fraction;

// unfold the based on parent offset
- (void)unfoldWithParentOffset:(float)offset;

@end
