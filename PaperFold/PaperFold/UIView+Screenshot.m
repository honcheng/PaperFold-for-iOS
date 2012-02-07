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
    //UIGraphicsBeginImageContext(self.frame.size);
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenshot;
}

@end
