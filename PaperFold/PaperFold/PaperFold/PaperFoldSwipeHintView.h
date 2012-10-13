//
//  PaperFoldSwipeHintView.h
//  SGBusArrivals
//
//  Created by honcheng on 13/10/12.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    PaperFoldSwipeHintViewModeSwipeLeft = 0,
    PaperFoldSwipeHintViewModeSwipeRight = 1,
} PaperFoldSwipeHintViewMode;

@interface PaperFoldSwipeHintView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) PaperFoldSwipeHintViewMode mode;
- (id)initWithPaperFoldSwipeHintViewMode:(PaperFoldSwipeHintViewMode)mode;
- (void)showInView:(UIView*)view;
+ (void)hidePaperFoldHintViewInView:(UIView*)view;


@end
