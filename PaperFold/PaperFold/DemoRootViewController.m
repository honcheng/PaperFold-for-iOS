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
@synthesize leftTableView = _leftTableView;
@synthesize centerTableView = _centerTableView;

- (id)init
{
    self = [super init];
    if (self) {
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,240,[self.view bounds].size.height)];
        [self.rightFoldView setContent:_mapView];
        
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_centerTableView setRowHeight:120];
        [self.contentView addSubview:_centerTableView];
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
        [_leftTableView setRowHeight:100];
        [self.leftFoldView setContent:_leftTableView];
    }
    return self;
}

@end
