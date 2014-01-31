//
//  NProgressIshView.m
//  NProgressIsh
//
//  Created by Josh Holtz on 1/31/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "NProgressIshView.h"

@interface NProgressIshView()

@property (nonatomic, strong) UIView *viewProgress;

@end

@implementation NProgressIshView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Initializes defaults
    _animationTime = 0.25f;
    
    // Sets up progress view
    _viewProgress = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, CGRectGetHeight(self.frame))];
    [_viewProgress setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self addSubview:_viewProgress];
}

#pragma mark - Public

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [_viewProgress setBackgroundColor:foregroundColor];
}

- (void)setProgress:(float)progress {
    // Makes sure progress is being set within bounds
    if (progress > 1.0f) { progress = 1.0f;
    } else if (progress < 0.0f) {progress = 0.0f;
    }
    _progress = progress;
    
    // Sets frame for progress width
    CGRect frame = _viewProgress.frame;
    frame.size.width = CGRectGetWidth(self.frame) * progress;
    
    // Animates progress
    [UIView animateWithDuration:_animationTime animations:^{
        [_viewProgress setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)start {
    [self setHidden:NO];
    [UIView animateWithDuration:_animationTime animations:^{
        [self setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)done {
    [UIView animateWithDuration:_animationTime animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

@end
