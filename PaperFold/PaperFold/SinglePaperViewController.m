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

#pragma mark Lift Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    SinglePaperFoldView *singlePaperFoldView = [[SinglePaperFoldView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) foldDirection:FoldDirectionHorizontalRightToLeft folds:4 pullFactor:0.9];
    [singlePaperFoldView setContent:self.contentView];
    singlePaperFoldView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:singlePaperFoldView];
    self.singlePaperFoldView = singlePaperFoldView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSinglePaperFoldView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark Button Event
- (IBAction)changeFoldOrUnfold:(id)sender {
    if ([self.singlePaperFoldView foldState] == FoldStateClosed) {
        [self.singlePaperFoldView unfoldPaper:YES Animation:YES];
    }
    else if ([self.singlePaperFoldView foldState] == FoldStateOpened) {
        [self.singlePaperFoldView unfoldPaper:NO Animation:YES];
    }
}

@end
