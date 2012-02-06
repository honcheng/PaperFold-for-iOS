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

        // create multiple FoldView next to each other
        for (int i=0; i<self.numberOfFolds; i++)
        {
            FoldView *foldView = [[FoldView alloc] initWithFrame:CGRectMake(foldWidth*i,0,foldWidth,frame.size.height)];
            [foldView setTag:FOLDVIEW_TAG+i];
            [self addSubview:foldView];
        }
    }
    return self;
}

// use the parent offset to calculate fraction
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

- (void)unfoldViewToFraction:(CGFloat)fraction
{
    // start the cascading effect of unfolding
    // with the first foldView with index FOLDVIEW_TAG+0
    FoldView *firstFoldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG];
    [self unfoldView:firstFoldView toFraction:fraction];
}

- (void)unfoldView:(FoldView*)foldView toFraction:(CGFloat)fraction
{
    // unfold the subfold
    [foldView unfoldViewToFraction:fraction];
    
    // check if there is another subfold beside this fold
    int index = [foldView tag] - FOLDVIEW_TAG;
    if (index < self.numberOfFolds-1)
    {
        FoldView *nextFoldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+index+1];
        // set the origin of the next foldView
        [nextFoldView setFrame:CGRectMake(foldView.frame.origin.x + 2*foldView.leftView.frame.size.width,0,nextFoldView.frame.size.width,nextFoldView.frame.size.height)];

        float foldWidth = self.frame.size.width/self.numberOfFolds;
        // calculate the offset between the right edge of the last subfold, and the edge of the screen
        // use this offset to readjust the fraction
        float x = self.superview.frame.origin.x+foldView.frame.origin.x+2*foldView.leftView.frame.size.width;
        CGFloat adjustedFraction = 0;
        if (index+1==self.numberOfFolds-1)
        {
            // if this is the last fold, do not use the pull factor 
            // so that the right edge of this subfold aligns with the right edge of the screen
            adjustedFraction = (-1*x)/(foldWidth);
        }
        else
        {
            // if this is not the last fold, use the pull factor
            adjustedFraction = (-1*x)/(foldWidth+self.pullFactor*foldWidth);
        }
        if (adjustedFraction < 0) adjustedFraction = 0;
        if (adjustedFraction > 1) adjustedFraction = 1;
        // unfold this foldView with the fraction
        // by calling the same function
        // this drills in to the next subfold in a cascading effect depending on the number of available folds
        [self unfoldView:nextFoldView toFraction:adjustedFraction];
    }
}

@end
