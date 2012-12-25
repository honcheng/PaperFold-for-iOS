
PaperFold for iOS
=================

PaperFold is a simple iOS control that allows hiding of views on the left and right side of the screen by dragging the middle view. 
The left view supports only 1 fold. The right view supports variable number of folds. 

<img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/1.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/2.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/3.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/4.png"/>

*Vertical fold is still in active testing, in an experimental branch (top-multifold) at the moment.*  

<img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/5-topfold.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/6-topfold.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/7-topfold.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/8-bottomfold.png"/> <img width=150 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/9-bottomfold.png"/>  
<img width=300 src="https://github.com/honcheng/PaperFold-for-iOS/raw/master/Screenshots/verticalfold.gif"/>


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

1) Add PaperFoldView as a subview into your view controller. 

    _paperFoldView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
    [self.view addSubview:_paperFoldView];

2) To set left view, use setLeftFoldContentView:foldCount:pullFactor:. Example below uses a UITableView, but it can any UIView.

    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
    [_paperFoldView setLeftFoldContentView:_leftTableView foldCount:3 pullFactor:0.9];

3) To set the right view, use setRightFoldContentView:foldCount:pullFactor:. Example below uses a MKMapView, but it can any UIView. The fold count is the number of folds in the right view. The pull factor controls the ratio of folding/unfolding of the different folds away from the center.

    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,240,[self.view bounds].size.height)];
    [_paperFoldView setRightFoldContentView:_mapView foldCount:3 pullFactor:0.9];

4) To set the center view

	_centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.height,[self.view bounds].size.height)];
    [_paperFoldView setCenterContentView:_centerTableView];

4) Sometimes you may want to disable drag-to-unfold if you have a table view in the center view and wish to preserve the swipe gesture functions e.g. to delete cells. 

    // this disables dragging to unfold the left view
    [self.paperFoldView setEnableLeftFoldDragging:NO];

    // this disables dragging to unfold the right view
    [self.paperFoldView setEnableRightFoldDragging:NO];


5) To unfold left view without dragging

    [self.paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded];

6) To unfold right view without dragging

    [self.paperFoldView setPaperFoldState:PaperFoldStateRightUnfolded];

7) To restore view to center without dragging

    [self.paperFoldView setPaperFoldState:PaperFoldStateDefault];

8) To receive callbacks when fold state changes, and if the fold was activated manually by finger gesture, or automatically by calling setPaperFoldState:

    // register callback delegate
    [self.paperFoldView setDelegate:self];

    // callback comes from the following delegate method 
    - (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automatic toState:(PaperFoldState)paperFoldState


Requirements
---

This project uses ARC. If you are not using ARC in your project, add '-fobjc-arc' as a compiler flag for all the files in this project.
XCode 4.4 is required for auto-synthesis.

Apps that uses PaperFold
------------------------

[Showy](https://itunes.apple.com/sg/app/id547022322)
, [LargeType](https://itunes.apple.com/sg/app/largetype-full-screen-text/id568459406)
, [NextRide](https://itunes.apple.com/us/app/nextride-singapore-public/id565103559) 
, [SG NextBus](https://itunes.apple.com/sg/app/sg-nextbus/id361404839)
, [Hangzhou Metro](https://itunes.apple.com/cn/app/hang-zhou-de-tie/id518531257?mt=8)

[Contact me](http://twitter.com/honcheng) if you want your app listed here. Thanks 


Other Projects that uses PaperFold
----------------------------------	

[PaperFoldMenuController](https://github.com/honcheng/PaperFoldMenuController) by me.

[PaperFold CocoaPod Demo for RubyMotion](https://github.com/yestoall/PaperFold-pod-DEMO) by [yestoall](yestoall).

[Titanium Mobile Mobule for PaperFold](https://github.com/atsusy/TiPaperFold) by [atsusy](https://github.com/atsusy/).

Known Problem
-------------

Screen capture of MKMapView is iOS6 is not taken properly. I approached a few Apple engineers at WWDC, and was told that it is most likely a bug that need to fix. I have already filed a bug report (filed as rdar://11813051, closed by Apple because it is a duplicate of rdar://11650331). Hopefully it will be fixed soon. 

**Update:** This bug is fixed in iOS6b4. No problem taking screenshot of MKMapView. 

Credits
------

Special thanks to [@dilliontan](http://twitter.com/dilliontan), my colleague in [buUuk](http://buuuk.com) for explaining CAAffineTransform. He's a master at that :p. I'm still a noob. 
You can check out his [iOS-Flip-Transform project here](https://github.com/Dillion/iOS-Flip-Transform).

Contact
------

[twitter.com/honcheng](http://twitter.com/honcheng)
[honcheng.com](http://honcheng.com)

![](http://www.cocoacontrols.com/analytics/honcheng/paperfold-for-ios.png)
