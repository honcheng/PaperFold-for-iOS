//
//  DemoRootViewController.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 7/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperFoldViewController.h"
#import <MapKit/MapKit.h>

@interface DemoRootViewController : PaperFoldViewController <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@end
