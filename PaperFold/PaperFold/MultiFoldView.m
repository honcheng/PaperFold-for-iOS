//
//  MultiFoldView.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 6/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "MultiFoldView.h"

@implementation MultiFoldView
@synthesize numberOfFolds;
@synthesize pullFactor;

#define FOLDVIEW_TAG 1000

- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)factor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfFolds = folds;
        self.pullFactor = factor;
        
        float foldWidth = frame.size.width/self.numberOfFolds;

        for (int i=0; i<self.numberOfFolds; i++)
        {
            FoldView *foldView = [[FoldView alloc] initWithFrame:CGRectMake(foldWidth*i,0,foldWidth,frame.size.height)];
            [foldView setTag:FOLDVIEW_TAG+i];
            [self addSubview:foldView];
        }
    }
    return self;
}

- (void)unfoldViewToFraction:(CGFloat)fraction
{
    FoldView *firstFoldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG];
    [self unfoldView:firstFoldView toFraction:fraction];
}

- (void)unfoldView:(FoldView*)foldView toFraction:(CGFloat)fraction
{
    [foldView unfoldViewToFraction:fraction];
    
    int index = [foldView tag] - FOLDVIEW_TAG;
    if (index < self.numberOfFolds-1)
    {
        FoldView *nextFoldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+index+1];
        [nextFoldView setFrame:CGRectMake(foldView.frame.origin.x + 2*foldView.leftView.frame.size.width,0,nextFoldView.frame.size.width,nextFoldView.frame.size.height)];

        float foldWidth = self.frame.size.width/self.numberOfFolds;
        float x = self.superview.frame.origin.x+foldView.frame.origin.x+2*foldView.leftView.frame.size.width;
        CGFloat adjustedFraction = 0;
        if (index+1==self.numberOfFolds-1)
        {
            adjustedFraction = (-1*x)/(foldWidth);
        }
        else
        {
            adjustedFraction = (-1*x)/(foldWidth+self.pullFactor*foldWidth);
        }
        if (adjustedFraction < 0) adjustedFraction = 0;
        if (adjustedFraction > 1) adjustedFraction = 1;
        [self unfoldView:nextFoldView toFraction:adjustedFraction];
    }
}

- (void)unfoldWithParentOffset:(float)offset
{
    float foldWidth = self.frame.size.width/self.numberOfFolds;
    if (offset<-1*(foldWidth+self.pullFactor*foldWidth))
    {
        offset = -1*(foldWidth+self.pullFactor*foldWidth);
    }
    CGFloat fraction = offset /(-1*(foldWidth+self.pullFactor*foldWidth));
    
    if (fraction < 0) fraction = 0;
    if (fraction > 1) fraction = 1;
    [self unfoldViewToFraction:fraction];
}

@end
