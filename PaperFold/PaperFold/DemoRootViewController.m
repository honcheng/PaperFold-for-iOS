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
@synthesize mapView = _mapView;
@synthesize leftTableView = _leftTableView;
@synthesize centerTableView = _centerTableView;

- (id)init
{
    self = [super init];
    if (self) {
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,240,[self.view bounds].size.height)];
        [self setRightFoldContentView:_mapView rightViewFoldCount:3 rightViewPullFactor:0.9];
        
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
        [_centerTableView setRowHeight:120];
        [self.contentView addSubview:_centerTableView];
        [_centerTableView setDelegate:self];
        [_centerTableView setDataSource:self];
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,100,[self.view bounds].size.height)];
        [_leftTableView setRowHeight:100];
        [self setLeftFoldContentView:_leftTableView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-1,0,1,[self.view bounds].size.height)];
        [self.contentView addSubview:line];
        [line setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake([self.view bounds].size.width,0,1,[self.view bounds].size.height)];
        [self.contentView addSubview:line2];
        [line2 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        
        // you may want to disable dragging to preserve tableview swipe functionality
        
        // disable left fold
        //[self setEnableLeftFoldDragging:NO];
        
        // disable right fold
        //[self setEnableRightFoldDragging:NO];
    }
    return self;
}

#pragma table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row==0) [cell.textLabel setText:@"<-- unfold left view"];
    else if (indexPath.row==1)[cell.textLabel setText:@"unfold right view -->"];
    else if (indexPath.row==2)[cell.textLabel setText:@"--> restore <--"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        // unfold left view
        [self unfoldLeftView];
    }
    else if (indexPath.row==1)
    {
        // unfold right view
        [self unfoldRightView];
    }
    else if (indexPath.row==2)
    {
        // restore to center
        [self restoreToCenter];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
