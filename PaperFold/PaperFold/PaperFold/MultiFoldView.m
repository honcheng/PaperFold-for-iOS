//
//  MultiFoldView.m
//  PaperFold
//
//  Created by Wang Hailong on 12-12-19.
//  Copyright (c) 2012年 honcheng@gmail.com. All rights reserved.
//

#import "MultiFoldView.h"

#import "UIView+Screenshot.h"
#import <MapKit/MapKit.h>

@interface MultiFoldView ()

// take screenshot just before unfolding
// this is only necessary for mapview, not for the rest of the views
@property (nonatomic, readonly) BOOL shouldTakeScreenshotBeforeUnfolding;

@end

@implementation MultiFoldView


#define FOLDVIEW_TAG 1000

- (id)initWithFrame:(CGRect)frame foldDirection:(FoldDirection)foldDirection folds:(int)folds pullFactor:(float)factor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _useOptimizedScreenshot = YES;
        _foldDirection = foldDirection;
        _numberOfFolds = folds;
        if (_numberOfFolds==1)
        {
            // no pull factor required if there is only one fold
            _pullFactor = 0;
        }
        else _pullFactor = factor;
        
        // create multiple FoldView next to each other
        for (int i=0; i<_numberOfFolds; i++)
        {
            if (_foldDirection==FoldDirectionHorizontalLeftToRight || _foldDirection==FoldDirectionHorizontalRightToLeft)
            {
                float foldWidth = frame.size.width/self.numberOfFolds;
                FoldView *foldView = [[FoldView alloc] initWithFrame:CGRectMake(foldWidth*i,0,foldWidth,frame.size.height) foldDirection:foldDirection];
                [foldView setTag:FOLDVIEW_TAG + i];
                [self addSubview:foldView];
            }
            else if (_foldDirection==FoldDirectionVerticalTopToBottom || _foldDirection==FoldDirectionVerticalBottomToTop)
            {
                float foldHeight = frame.size.height/self.numberOfFolds;
                FoldView *foldView = [[FoldView alloc] initWithFrame:CGRectMake(0,foldHeight*i,frame.size.width,foldHeight) foldDirection:foldDirection];
                [foldView setTag:FOLDVIEW_TAG+i];
                [self addSubview:foldView];
            }
        }
        [self setAutoresizesSubviews:YES];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame folds:(int)folds pullFactor:(float)factor
{
    return [self initWithFrame:frame foldDirection:FoldDirectionHorizontalRightToLeft folds:folds pullFactor:factor];
}

- (void)setContent:(UIView *)contentView
{
    if ([contentView isKindOfClass:NSClassFromString(@"MKMapView")]) _shouldTakeScreenshotBeforeUnfolding = YES;
    
    // set the content view
    self.contentViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    //[self.contentView setFrame:CGRectMake(0,0,contentView.frame.size.width,contentView.frame.size.height)];
    [self.contentViewHolder setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleWidth];
    // place content view below folds
    [self insertSubview:self.contentViewHolder atIndex:0];
    [self.contentViewHolder addSubview:contentView];
    // immediately take a screenshot of the content view to overlay in fold
    // if content view is a map view, screenshot will be a blank grid
    [self drawScreenshotOnFolds];
    [self.contentViewHolder setHidden:YES];
}

// get screenshot of content to overlay in folds
- (void)drawScreenshotOnFolds
{
    UIImage *image = [self.contentViewHolder screenshotWithOptimization:self.useOptimizedScreenshot];
    [self setScreenshotImage:image];
    // get screenshot of content view, and splice the image to overlay in different folds
}

- (void)setScreenshotImage:(UIImage*)image
{
    if (self.foldDirection==FoldDirectionHorizontalLeftToRight || self.foldDirection==FoldDirectionHorizontalRightToLeft)
    {
        float foldWidth = image.size.width/self.numberOfFolds;
        
        for (int i=0; i<self.numberOfFolds; i++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(foldWidth*i*image.scale, 0, foldWidth*image.scale, image.size.height*image.scale));
            if (imageRef)
            {
                UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
                CFRelease(imageRef);
                FoldView *foldView = nil;
                if (self.foldDirection==FoldDirectionHorizontalLeftToRight) {
                    foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG + (self.numberOfFolds - 1) - i];
                } else {
                    foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+i];
                }
                [foldView setImage:croppedImage];
            }
            
        }
    }
    else if (self.foldDirection==FoldDirectionVerticalTopToBottom || self.foldDirection==FoldDirectionVerticalBottomToTop)
    {
        float foldHeight = image.size.height/self.numberOfFolds;
        for (int i=0; i<self.numberOfFolds; i++)
        {
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, foldHeight*(self.numberOfFolds-i-1)*image.scale, image.size.width*image.scale, foldHeight*image.scale));
            if (imageRef)
            {
                UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
                CFRelease(imageRef);
                FoldView *foldView = nil;
                if (self.foldDirection==FoldDirectionVerticalTopToBottom) {
                    foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG+i];
                } else {
                    foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG + (self.numberOfFolds - 1) - i];
                }
                [foldView setImage:croppedImage];
            }
        }
    }
}

#pragma mark Unfold Animation
// set fold states based on offset value
- (void)calculateFoldStateFromOffset:(float)offset
{
    CGFloat fraction = 0.0;
    if (self.foldDirection==FoldDirectionHorizontalRightToLeft || self.foldDirection==FoldDirectionHorizontalLeftToRight)
    {
        fraction = offset/self.frame.size.width;
    }
    else if (self.foldDirection==FoldDirectionVerticalTopToBottom || self.foldDirection==FoldDirectionVerticalBottomToTop)
    {
        fraction = offset/self.frame.size.height;
    }
    
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
        else if (fraction>=1)
        {
            _state = FoldStateOpened;
            [self foldDidOpened];
        }
    }
}

- (void)unfoldViewToFraction:(CGFloat)fraction {
    if (self.foldDirection == FoldDirectionHorizontalLeftToRight || self.foldDirection == FoldDirectionHorizontalRightToLeft) {
        [self unfoldWithParentOffset:fraction * self.frame.size.width];
    }
    else if (self.foldDirection == FoldDirectionVerticalBottomToTop || self.foldDirection == FoldDirectionVerticalTopToBottom) {
        [self unfoldWithParentOffset:fraction * self.frame.size.height];
    }
}

- (void)unfoldWithParentOffset:(float)offset
{
    // start the cascading effect of unfolding
    // with the first foldView with index FOLDVIEW_TAG+0
    if (offset < 0) {
        NSLog(@"Error! %s offset MUST BE a Positive Number %f",__func__, offset);
        offset = -offset;
    }
    [self calculateFoldStateFromOffset:offset];
    if (self.foldDirection == FoldDirectionHorizontalLeftToRight) {
        [self unfoldLeftToRightViewWithParentOffset:offset];
    } else if (self.foldDirection == FoldDirectionHorizontalRightToLeft) {
        [self unfoldRightToLeftViewWithParentOffset:offset];
    } else if (self.foldDirection == FoldDirectionVerticalTopToBottom) {
        [self unfoldTopToBottomViewWithParentOffset:offset];
    } else if (self.foldDirection == FoldDirectionVerticalBottomToTop) {
        [self unfoldBottomToTopViewWithParentOffset:offset];
    }
}

- (void)unfoldLeftToRightViewWithParentOffset:(float)offset {
    float foldWidth = self.frame.size.width/self.numberOfFolds;
    CGFloat fraction;
    
    float foldOffSet = offset;
    for (int index = 0; index < self.numberOfFolds; index ++) {
        if (index == self.numberOfFolds - 1) {
            fraction = foldOffSet / foldWidth;
        } else {
            fraction = foldOffSet / (foldWidth + self.pullFactor * foldWidth);
        }
        if (fraction > 1) fraction = 1; // This make sure fraction must <= 1
        
        FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG + index];
        [foldView unfoldViewToFraction:fraction];
        [foldView setFrame:CGRectMake(foldOffSet - [foldView realSize].width, 0, foldView.frame.size.width, foldView.frame.size.height)];
        foldOffSet = foldView.frame.origin.x;
    }
}

- (void)unfoldRightToLeftViewWithParentOffset:(float)offset {
    float foldWidth = self.frame.size.width/self.numberOfFolds;
    CGFloat fraction;
    
    float foldOffSet = 0;
    for (int index = 0; index < self.numberOfFolds; index ++) {
        if (index == self.numberOfFolds - 1) {
            fraction = (offset - foldOffSet) / foldWidth;
        } else {
            fraction = (offset - foldOffSet) / (foldWidth + self.pullFactor * foldWidth);
        }
        if (fraction > 1) fraction = 1; // This make sure fraction must <= 1
        
        FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG + index];
        [foldView unfoldViewToFraction:fraction];
        [foldView setFrame:CGRectMake(foldOffSet, 0, foldView.frame.size.width, foldView.frame.size.height)];
        foldOffSet = foldView.frame.origin.x + [foldView realSize].width;
    }
}

- (void)unfoldTopToBottomViewWithParentOffset:(float)offset {
    float foldHeight = self.frame.size.height/self.numberOfFolds;
    CGFloat fraction;
    
    float foldOffSet = 0;
    for (int index = 0; index < self.numberOfFolds; index ++) {
        if (index == self.numberOfFolds - 1) {
            fraction = (offset - foldOffSet) / foldHeight;
        } else {
            fraction = (offset - foldOffSet) / (foldHeight + self.pullFactor * foldHeight);
        }
        if (fraction > 1) fraction = 1; // This make sure fraction must <= 1
        
        FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG + index];
        [foldView unfoldViewToFraction:fraction];
        [foldView setFrame:CGRectMake(0, self.frame.size.height - foldOffSet - foldView.frame.size.height, foldView.frame.size.width, foldView.frame.size.height)];
        
        foldOffSet += [foldView realSize].height;
    }
}

- (void)unfoldBottomToTopViewWithParentOffset:(float)offset {
    float foldHeight = self.frame.size.height/self.numberOfFolds;
    CGFloat fraction;
    float foldOffSet = offset;
    for (int index = 0; index < self.numberOfFolds; index ++) {
        if (index == self.numberOfFolds - 1) {
            fraction = foldOffSet / foldHeight;
        } else {
            fraction = foldOffSet / (foldHeight + self.pullFactor * foldHeight);
        }
        if (fraction > 1) fraction = 1; // This make sure fraction must <= 1
        
        FoldView *foldView = (FoldView*)[self viewWithTag:FOLDVIEW_TAG + index];
        [foldView unfoldViewToFraction:fraction];
        [foldView setFrame:CGRectMake(0, self.frame.size.height - foldOffSet - (foldView.frame.size.height - [foldView realSize].height), foldView.frame.size.width, foldView.frame.size.height)];
        foldOffSet -= [foldView realSize].height;
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

- (void)unfoldWithoutAnimation
{
    [self unfoldWithParentOffset:self.frame.size.width];
    [self foldDidOpened];
}

#pragma mark states

// when fold is completely opened, hide fold and show content view
- (void)foldDidOpened
{
    [self.contentViewHolder setHidden:NO];
    [self showFolds:NO];
}

// when fold is completely closed, hide content view and folds
- (void)foldDidClosed
{
    [self.contentViewHolder setHidden:YES];
    [self showFolds:YES];
}

// when fold is about to be opened, make sure content view is hidden, and show fold
- (void)foldWillOpen
{
    if (self.shouldTakeScreenshotBeforeUnfolding)
    {
        [self.contentViewHolder setHidden:NO];
        [self drawScreenshotOnFolds];
    }
    [self.contentViewHolder setHidden:YES];
    [self showFolds:YES];
}

// when fold is about to be closed, take a screenshot of the content view, hide it, and make sure fold is visible.
- (void)foldWillClose
{
    [self drawScreenshotOnFolds];
    [self.contentViewHolder setHidden:YES];
    [self showFolds:YES];
}

@end
