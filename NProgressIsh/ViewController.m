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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_nProgressIshViewIB setForegroundColor:[UIColor redColor]];
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
    
}

@end
