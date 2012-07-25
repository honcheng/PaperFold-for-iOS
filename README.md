
PaperFold for iOS
=================

PaperFold is a simple iOS control that allows hiding of views on the left and right side of the screen by dragging the middle view. 
The left view supports only 1 fold. The right view supports variable number of folds. 

<img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/1.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/2.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/3.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/4.png"/>

How it works
------------

During folding, a screen capture of the left/right view is taken, and split up depending on the number of folds required. The virtual light source is on the right side of the screen, so surfaces that faces the left are darker. For the right multi-fold view, the fold closes to the 'force' are opened up faster than the folds that is further away.

A sample project is included.

Example
-------

Refer to this [link](http://www.honcheng.com/2012/02/Playing-with-folding-navigations) for a video showing the prototype of an app that I was working on. In the end, the proposed project was never completed because I could not obtained reliable data for the app, but I intend to use it for another app. 

<img width=300 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/leftfold.gif"/> <img width=300 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/rightfold.gif"/>

The animation here looks a bit laggy, but that's because of the low frame rates in GIF.

Usage
-----

1) Subclass PaperFoldViewController in the view controller that will be using the left/right fold views.

2) To set left view, use setLeftFoldContentView:. Example below uses a UITableView, but it can any UIView.
	
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
    [self setLeftFoldContentView:_leftTableView];

3) To set the right view, use setRightFoldContentView:rightViewFoldCount:rightViewPullFactor:. Example below uses a MKMapView, but it can any UIView. The fold count is the number of folds in the right view. The pull factor controls the ratio of folding/unfolding of the different folds away from the center.
	
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,240,[self.view bounds].size.height)];
    [self setRightFoldContentView:_mapView rightViewFoldCount:3 rightViewPullFactor:0.9];

ARC
---

This project uses ARC. If you are not using ARC in your project, add '-fobjc-arc' as a compiler flag for all the files in this project.

Known Problem
-------------

Screen capture of MKMapView is iOS6 is not taken properly. I approached a few Apple engineers at WWDC, and was told that it is most likely a bug that need to fix. I have already filed a bug report. Hopefully it will be fixed soon. 

[twitter.com/honcheng](http://twitter.com/honcheng)
