//
//  UIView+Screenshot.h
//  PaperFold
//
//  Created by Hon Cheng Muh on 7/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(UIImage *image);

@interface UIView (Screenshot)
- (UIImage*)screenshot;
- (UIImage*)openGLSnapshot;
- (void)takeScreenshot:(CompletionBlock)block;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@end
