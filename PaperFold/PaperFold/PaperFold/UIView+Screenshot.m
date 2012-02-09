//
//  UIView+Screenshot.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 7/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "UIView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Screenshot)

- (UIImage*)screenshot
{
    // take screenshot of the view
    if ([self isKindOfClass:NSClassFromString(@"MKMapView")])
    {
        // if the view is a mapview, screenshot has to take the screen scale into consideration
        // else, the screen shot in retina display devices will be of a less detail map (note, it is not the size of the screenshot, but it is the level of detail of the screenshot 
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    }
    else 
    {
        // for performance consideration, everything else other than mapview will use a lower quality screenshot
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenshot;
}

- (void)takeScreenshot:(CompletionBlock)block
{
    dispatch_queue_t queue = dispatch_queue_create("screenshot", 0);
    dispatch_async(queue, ^(void) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        dispatch_async(dispatch_get_main_queue(), ^{
            block(screenshot);
        });
        dispatch_release(queue);
    });
}

@end
