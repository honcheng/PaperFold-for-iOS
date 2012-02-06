//
//  FoldView.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacingView.h"

@interface FoldView : UIView

// each folderView consists of 2 facing views: leftView and rightView
@property (strong) FacingView *leftView, *rightView;

// unfold the 2 facing views using a fraction 0 to 1
// 0 when it's completely folded
// 1 when it's completely unfolded
- (void)unfoldViewToFraction:(CGFloat)fraction;

@end
