//
//  PaperFoldConstants.h
//  PaperFold
//
//  Created by honcheng on 25/8/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#ifndef PaperFold_PaperFoldConstants_h
#define PaperFold_PaperFoldConstants_h

#define FOLDVIEW_TAG 1000
#define kLeftViewUnfoldThreshold 0.3
#define kRightViewUnfoldThreshold 0.3
#define kTopViewUnfoldThreshold 0.3
#define kBottomViewUnfoldThreshold 0.3
#define kEdgeScrollWidth 40.0

typedef enum
{
    FoldStateClosed = 0,
    FoldStateOpened = 1,
    FoldStateTransition = 2
} FoldState;

typedef enum
{
    FoldDirectionHorizontalRightToLeft = 0,
    FoldDirectionHorizontalLeftToRight = 1,
    FoldDirectionVertical = 2,
} FoldDirection;

typedef enum
{
    PaperFoldStateDefault = 0,
    PaperFoldStateLeftUnfolded = 1,
    PaperFoldStateRightUnfolded = 2,
    PaperFoldStateTopUnfolded = 3,
    PaperFoldStateBottomUnfolded = 4,
    PaperFoldStateTransition = 5
} PaperFoldState;

typedef enum
{
    PaperFoldInitialPanDirectionHorizontal = 0,
    PaperFoldInitialPanDirectionVertical = 1,
} PaperFoldInitialPanDirection;

#endif
