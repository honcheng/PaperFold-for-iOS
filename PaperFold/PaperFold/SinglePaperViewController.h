//
//  SinglePaperViewController.h
//  PaperFold
//
//  Created by Wang Hailong on 12-12-20.
//  Copyright (c) 2012年 honcheng@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinglePaperFoldView;
@interface SinglePaperViewController : UIViewController

@property (weak, nonatomic) SinglePaperFoldView *singlePaperFoldView;
@property (weak, nonatomic) IBOutlet UIImageView *contentView;

- (IBAction)changeFoldOrUnfold:(id)sender;

@end
