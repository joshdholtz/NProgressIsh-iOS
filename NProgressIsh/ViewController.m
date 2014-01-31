//
//  ViewController.m
//  NProgressIsh
//
//  Created by Josh Holtz on 1/31/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "NProgressIshView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NProgressIshView *nProgressIshViewIB;

@property (nonatomic, strong) NProgressIshView *progTop;
@property (nonatomic, strong) NProgressIshView *progBottom;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_nProgressIshViewIB setForegroundColor:[UIColor redColor]];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _progTop = [NProgressIshView showAtTopOfView:self.view];
    [_progTop trickle:YES];
    
    _progBottom = [NProgressIshView showAtBottomOfView:self.view];
    [_progBottom setAnimationTime:1.5f];
    [_progBottom indefinite:YES];
    
    [_nProgressIshViewIB setAnimationTime:1.5f];
    [_nProgressIshViewIB indefinite:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)onClickIncrement:(id)sender {
    [_nProgressIshViewIB setProgress:(_nProgressIshViewIB.progress + 0.1f)];
}

- (IBAction)onClickDecrement:(id)sender {
    [_nProgressIshViewIB setProgress:(_nProgressIshViewIB.progress - 0.1f)];
}

- (IBAction)onClickReloadView:(id)sender {
    [_progTop trickle:NO];
    [_progBottom trickle:NO];
    
    [_progTop setProgress:0.0f animated:NO];
    [_progBottom setProgress:0.0f animated:NO];
    
    [_progTop trickle:YES];
    [_progBottom trickle:YES];
}

@end
