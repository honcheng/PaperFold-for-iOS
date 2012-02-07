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
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /*
    NSLog(@">>>> %f %f %f", screenshot.size.width, screenshot.size.height, screenshot.scale);
    
    NSData *data = UIImagePNGRepresentation(screenshot);
    UIImage *image2 = [UIImage imageWithData:data];
    NSLog(@"%f %f %f", image2.size.width, image2.size.height, image2.scale);
    
    return image2;
    */
    return screenshot;
}

@end
