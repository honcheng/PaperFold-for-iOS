//
//  DemoRootViewController.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 7/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "DemoRootViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+Screenshot.h"

@implementation DemoRootViewController
@synthesize mapView = _mapView;

- (id)init
{
    self = [super init];
    if (self) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake([self.view bounds].size.width-240,0,240,[self.view bounds].size.height)];
        //[self.view insertSubview:_mapView belowSubview:self.contentView];
        [_mapView setDelegate:self];
        [self.rightFoldView setContent:_mapView];
    }
    return self;
}

@end
