//
//  SinglePaperViewController.m
//  PaperFold
//
//  Created by Wang Hailong on 12-12-20.
//  Copyright (c) 2012年 honcheng@gmail.com. All rights reserved.
//

#import "SinglePaperViewController.h"

#import "SinglePaperFoldView.h"

@interface SinglePaperViewController ()

@end

@implementation SinglePaperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SinglePaperFoldView *singlePaperFoldView = [[SinglePaperFoldView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) foldDirection:FoldDirectionHorizontalRightToLeft folds:4 pullFactor:0.9];
    [singlePaperFoldView setContent:self.contentView];
    singlePaperFoldView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:singlePaperFoldView];
    self.singlePaperFoldView = singlePaperFoldView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.singlePaperFoldView unfoldPaper:YES Animation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSinglePaperFoldView:nil];
    [super viewDidUnload];
}

@end
