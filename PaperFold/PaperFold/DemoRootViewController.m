/**
 * Copyright (c) 2012 Muh Hon Cheng
 * Created by honcheng on 7/2/12.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 * IN CONNECTION WITH THE SOFTWARE OR
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2012	Muh Hon Cheng
 * @version
 *
 */

#import "DemoRootViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+Screenshot.h"

@implementation DemoRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        _paperFoldView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_paperFoldView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:_paperFoldView];
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,240,[self.view bounds].size.height)];
        [_paperFoldView setRightFoldContentView:_mapView foldCount:3 pullFactor:0.9];
        
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_centerTableView setRowHeight:120];
        [_paperFoldView setCenterContentView:_centerTableView];
        [_centerTableView setDelegate:self];
        [_centerTableView setDataSource:self];
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,150,[self.view bounds].size.height)];
        [_leftTableView setRowHeight:100];
        [_leftTableView setDataSource:self];
        [_paperFoldView setLeftFoldContentView:_leftTableView foldCount:3 pullFactor:0.9];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-1,0,1,[self.view bounds].size.height)];
        [_paperFoldView.contentView addSubview:line];
        [line setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake([self.view bounds].size.width,0,1,[self.view bounds].size.height)];
        [_paperFoldView.contentView addSubview:line2];
        [line2 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight];
        [line2 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        
        [_paperFoldView setDelegate:self];
        
        // you may want to disable dragging to preserve tableview swipe functionality
        
        // disable left fold
        //[_paperFoldView setEnableLeftFoldDragging:NO];
        
        // disable right fold
        //[_paperFoldView setEnableRightFoldDragging:NO];
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,300)];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        UILabel *topLabel = [[UILabel alloc] initWithFrame:_topView.frame];
        [topLabel setText:@"A"];
        [topLabel setBackgroundColor:[UIColor clearColor]];
        [topLabel setFont:[UIFont boldSystemFontOfSize:300]];
        [topLabel setTextAlignment:UITextAlignmentCenter];
        [_topView addSubview:topLabel];
        
        ShadowView *topShadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0,_topView.frame.size.height-5,_topView.frame.size.width,5) foldDirection:FoldDirectionVertical];
        [topShadowView setColorArrays:@[[UIColor colorWithWhite:0 alpha:0.3],[UIColor clearColor]]];
        [_topView addSubview:topShadowView];
        
        [_paperFoldView setTopFoldContentView:_topView topViewFoldCount:5 topViewPullFactor:0.9];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,160)];
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:_bottomView.frame];
        [bottomLabel setText:@"A"];
        [bottomLabel setFont:[UIFont boldSystemFontOfSize:150]];
        [bottomLabel setTextAlignment:UITextAlignmentCenter];
        [_bottomView addSubview:bottomLabel];
        
        ShadowView *bottomShadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0,0,_topView.frame.size.width,5) foldDirection:FoldDirectionVertical];
        [bottomShadowView setColorArrays:@[[UIColor clearColor],[UIColor colorWithWhite:0 alpha:0.3]]];
        [_bottomView addSubview:bottomShadowView];
        
        [_paperFoldView setBottomFoldContentView:_bottomView];
        
#warning disabling scroll, requires tapping cell twice to select cells. to be fixed
        [_centerTableView setScrollEnabled:NO];
        //[_paperFoldView setEnableHorizontalEdgeDragging:YES];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.leftTableView) return 10;
    else return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView==self.leftTableView)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"%i", indexPath.row]];
    }
    else
    {
        if (indexPath.row==0) [cell.textLabel setText:@"<-- unfold left view"];
        else if (indexPath.row==1)[cell.textLabel setText:@"unfold right view -->"];
        else if (indexPath.row==2)[cell.textLabel setText:@"--> restore <--"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.centerTableView)
    {
        NSLog(@"did select");
        if (indexPath.row==0)
        {
            // unfold left view
            [self.paperFoldView setPaperFoldState:PaperFoldStateLeftUnfolded];
        }
        else if (indexPath.row==1)
        {
            // unfold right view
            [self.paperFoldView setPaperFoldState:PaperFoldStateRightUnfolded];
        }
        else if (indexPath.row==2)
        {
            // restore to center
            [self.paperFoldView setPaperFoldState:PaperFoldStateDefault];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark paper fold delegate

- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState
{
    NSLog(@"did transition to state %i automated %i", paperFoldState, automated);
}

@end
