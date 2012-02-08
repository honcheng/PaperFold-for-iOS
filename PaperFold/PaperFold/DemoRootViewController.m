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
        //[_mapView setDelegate:self];
        
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_centerTableView setRowHeight:120];
        [self.contentView addSubview:_centerTableView];
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
        [_leftTableView setRowHeight:100];
        [self.leftFoldView setContent:_leftTableView];
    }
    return self;
}

/*
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    
    if (self.rightFoldView.state==FoldStateOpened)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self.rightFoldView selector:@selector(drawScreenshotOnFolds) object:nil];
        [self.rightFoldView performSelector:@selector(drawScreenshotOnFolds) withObject:nil afterDelay:0.1];
        //[self.rightFoldView drawScreenshotOnFolds];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.rightFoldView.state==FoldStateOpened)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self.rightFoldView selector:@selector(drawScreenshotOnFolds) object:nil];
        [self.rightFoldView performSelector:@selector(drawScreenshotOnFolds) withObject:nil afterDelay:0.1];
        //[self.rightFoldView drawScreenshotOnFolds];
    }
    
}*/

@end
