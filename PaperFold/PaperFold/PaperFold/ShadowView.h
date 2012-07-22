//
//  ShadowView.h
//  SGBusArrivals
//
//  Created by honcheng on 2/12/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShadowView : UIView
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) CAGradientLayer *gradient;

- (void)setColorArrays:(NSMutableArray*)colors;

@end
