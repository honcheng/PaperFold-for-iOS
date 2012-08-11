/**
 * Copyright (c) 2012 Muh Hon Cheng
 * Created by honcheng on 6/2/12.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 * IN CONNECTION WITH THE SOFTWARE OR
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2012	Muh Hon Cheng
 * @version
 *
 */


#import "MultiFoldView.h"
#import "UIView+Screenshot.h"

@implementation MultiFoldView
@synthesize numberOfFolds;
@synthesize pullFactor;
@synthesize contentView = _contentView;
@synthesize state = _state;

#define FOLDVIEW_TAG 1000

- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)factor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfFolds = folds;
        if (self.numberOfFolds==1)
        {
            // no pull factor required if there is only one fold
            self.pullFactor = 0;
        }
        else self.pullFactor = factor;
        
        float foldWidth = frame.size.width/self.numberOfFolds;

        // create multiple FoldView next to each other
        for (int i=0; i<self.numberOfFolds; i++)
        {
            FoldView *foldView = [[FoldView alloc] initWithFrame:CGRectMake(foldWidth*i,0,foldWidth,frame.size.height)];
            [foldView setTag:FOLDVIEW_TAG+i];
            [self addSubview:foldView];
        }
        [self setAutoresizesSubviews:YES];
    }
    return self;
}

- (void)setContent:(UIView *)contentView
{
    // set the content view
    self.contentView = contentView;
    [self.contentView setFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleWidth];
    // place content view below folds
    [self insertSubview:self.contentView atIndex:0];
    // immediately take a screenshot of the content view to overlay in fold
    // if content view is a map view, screenshot will be a blank grid
    [self drawScreenshotOnFolds];
    [self.contentView setHidden:YES];
}

- (void)drawScreenshotOnFolds
{

    UIImage *image = [self.contentView screenshot];
    // get screenshot of content view, and splice the image to overlay in different folds
    float foldWidth = image.size.width/self.numberOfFolds;
    for (int i=0; i<self.numberOfFolds; i++)
    {
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(foldWidth*i*image.scale, 0, foldWidth*image.scale, image.size.height*image.scale));
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        CFRelease(imageRef);
        FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+i];
        [foldView setImage:croppedImage];
    }
    /*
    [self takeScreenshot:^(UIImage *image) {
        float foldWidth = image.size.width/self.numberOfFolds;
        for (int i=0; i<self.numberOfFolds; i++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(foldWidth*i*image.scale, 0, foldWidth*image.scale, image.size.height*image.scale));
            UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
            CFRelease(imageRef);
            FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+i];
            [foldView setImage:croppedImage];
        }
    }];*/
}

// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset
{
    CGFloat fraction = -1*offset/self.frame.size.width;
    if (_state==FoldStateClosed && fraction>0)
    {
        _state = FoldStateTransition;
        [self foldWillOpen];
    }
    else if (_state==FoldStateOpened && fraction<1)
    {
        _state = FoldStateTransition;
        [self foldWillClose];
        
    }
    else if (_state==FoldStateTransition)
    {
        if (fraction==0)
        {
            _state = FoldStateClosed;
            [self foldDidClosed];
        }
        else if (fraction==1)
        {
            _state = FoldStateOpened;
            [self foldDidOpened];
        }
    }
}

// use the parent offset to calculate fraction
- (void)unfoldWithParentOffset:(float)offset
{
    [self calculateFoldStateFromOffset:offset];
    
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

// hide fold (when content view is visible) and show fold (when content view is hidden
- (void)showFolds:(BOOL)show
{
    for (int i=0; i<self.numberOfFolds; i++)
    {
        FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+i];
        [foldView setHidden:!show];
    }
}

#pragma mark states

// when fold is completely opened, hide fold and show content view
- (void)foldDidOpened
{
    [self.contentView setHidden:NO];
    [self showFolds:NO];
}

// when fold is completely closed, hide content view and folds
- (void)foldDidClosed
{
    [self.contentView setHidden:YES];
    [self showFolds:YES];
}

// when fold is about to be opened, make sure content view is hidden, and show fold
- (void)foldWillOpen
{
    [self.contentView setHidden:YES];
    [self showFolds:YES];
}

// when fold is about to be closed, take a screenshot of the content view, hide it, and make sure fold is visible.
- (void)foldWillClose
{
    [self drawScreenshotOnFolds];
    [self.contentView setHidden:YES];
    [self showFolds:YES];
}



@end
