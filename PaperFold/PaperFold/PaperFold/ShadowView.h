//
//  ShadowView.h
//  SGBusArrivals
//
//  Created by honcheng on 2/12/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShadowView : UIView {
	CAGradientLayer *gradient;
	NSMutableArray *_colorsArray;
}
@property (nonatomic, retain) NSMutableArray *_colorsArray;
@property (nonatomic, retain) CAGradientLayer *gradient;

- (void)setColorArrays:(NSMutableArray*)colors;

@end
