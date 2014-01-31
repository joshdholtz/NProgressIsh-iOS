//
//  NProgressIshView.m
//  NProgressIsh
//
//  Created by Josh Holtz on 1/31/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "NProgressIshView.h"

#import <QuartzCore/QuartzCore.h>

@interface NProgressIshView()

@property (nonatomic, strong) UIView *viewProgress;
@property (nonatomic, strong) UIView *viewIndefiniteProgress;

@property (nonatomic, assign) BOOL trickle;
@property (nonatomic, assign) BOOL indeterminateState;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NProgressIshView

#pragma mark - Class

static float const DEFAULT_HEIGHT = 8.0f;

+ (NProgressIshView *)showAtTopOfView:(UIView *)view {
    NProgressIshView *prog = [[NProgressIshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), DEFAULT_HEIGHT)];
//    [prog setAlpha:0.0f];
    
    [prog setBackgroundColor:[UIColor grayColor]];
    [prog setForegroundColor:[UIColor colorWithRed:0.4f green:0.6f blue:0.8f alpha:1.0f]];
    
    [view addSubview:prog];
    
    return prog;
}

+ (NProgressIshView *)showAtBottomOfView:(UIView *)view {
    NProgressIshView *prog = [[NProgressIshView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(view.frame) - DEFAULT_HEIGHT, CGRectGetWidth(view.frame), DEFAULT_HEIGHT)];
    [prog setAlpha:0.0f];
    [prog setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    [prog setBackgroundColor:[UIColor clearColor]];
    [prog setForegroundColor:[UIColor colorWithRed:0.4f green:0.6f blue:0.8f alpha:1.0f]];
    
    [view addSubview:prog];
    
    return prog;
}

+ (BOOL)hideProgressForView:(UIView *)view {
    NProgressIshView *prog = [self progressForView:view];
	if (prog != nil) {
		[prog setRemoveFromSuperviewOnHide:YES];
		[prog done];
		return YES;
	}
	return NO;
}

+ (NSInteger)hideAllProgressForView:(UIView *)view {
    NSArray *progresses = [self allProgressForView:view];
	for (NProgressIshView *prog in progresses) {
		[prog setRemoveFromSuperviewOnHide:YES];
		[prog done];
	}
	return [progresses count];
}

+ (NProgressIshView *)progressForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (NProgressIshView *)subview;
		}
	}
	return nil;
}

+ (NSArray *)allProgressForView:(UIView *)view {
    NSMutableArray *progresses = [NSMutableArray array];
	for (UIView *subview in view.subviews) {
		if ([subview isKindOfClass:self]) {
			[progresses addObject:subview];
		}
	}
	return [NSArray arrayWithArray:progresses];
}

#pragma mark - Instance

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
    _trickleRate = 0.05f;
    _trickleSpeed = 0.5f;
    
    [self setClipsToBounds:NO];
    
    // Sets up progress view
    _viewProgress = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, CGRectGetHeight(self.frame))];
    [_viewProgress setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_viewProgress setClipsToBounds:NO];
    [self addSubview:_viewProgress];
    
    // Sets up indefinite progress view
    _viewIndefiniteProgress = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2.0f, 0.0f, 0.0f, CGRectGetHeight(self.frame))];
    [_viewIndefiniteProgress setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [_viewIndefiniteProgress setClipsToBounds:NO];
    [self addSubview:_viewIndefiniteProgress];
}

#pragma mark - Public

- (void)setForegroundColor:(UIColor *)foregroundColor {
    [_viewProgress setBackgroundColor:foregroundColor];
    [_viewIndefiniteProgress setBackgroundColor:foregroundColor];
    
    // Glow
    [_viewProgress.layer setShadowColor:foregroundColor.CGColor];
    [_viewIndefiniteProgress.layer setShadowColor:foregroundColor.CGColor];

    [self setGlow:CGSizeMake(0.0f, 0.0f) opacity:0.5f raidus:3.0f];
}

- (void)setGlow:(CGSize)size opacity:(CGFloat)opacity raidus:(CGFloat)radius {
    [_viewProgress.layer setShadowOffset:size];
    [_viewProgress.layer setShadowOpacity:opacity];
    [_viewProgress.layer setShadowRadius:radius];
    
    [_viewIndefiniteProgress.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [_viewIndefiniteProgress.layer setShadowOpacity:opacity];
    [_viewIndefiniteProgress.layer setShadowRadius:radius];
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:YES];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    // Makes sure progress is being set within bounds
    if (progress > 1.0f) { progress = 1.0f;
    } else if (progress < 0.0f) {progress = 0.0f;
    }
    _progress = progress;
    
    // Sets frame for progress width
    CGRect frame = _viewProgress.frame;
    frame.size.width = CGRectGetWidth(self.frame) * progress;
    
    // Animates progress
    [UIView animateWithDuration:( animated ? _animationTime : 0.0f ) animations:^{
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
    [_timer invalidate];
    _timer = nil;
    
    [UIView animateWithDuration:_animationTime animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        if (_removeFromSuperviewOnHide == YES) {
            [self removeFromSuperview];
        }
    }];
}

- (void)trickle:(BOOL)trickle {
    if (trickle == YES && _timer == nil) {
        _trickle = trickle;
        
        [_timer invalidate];
        _timer = nil;
        
        [self start];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_trickleSpeed target:self selector:@selector(onTrickle) userInfo:nil repeats:YES];
    } else if (trickle == NO) {
        _trickle = trickle;
        
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)indeterminate:(BOOL)indeterminate {
    [self indeterminate:indeterminate startFull:NO];
}

- (void)indeterminate:(BOOL)indeterminate startFull:(BOOL)startFull {
    if (indeterminate == YES && _timer == nil) {
        _indeterminateState = indeterminate;
        
        [self setProgress:0.0f animated:0.0];
        
        [_timer invalidate];
        _timer = nil;
        
        [self start];
        if (startFull == NO) {
            CGRect frame = _viewIndefiniteProgress.frame;
            frame.origin.x = 0.0f;
            frame.size.width = 0.0f;
            [_viewIndefiniteProgress setFrame:frame];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(onIndefiniteGrow) userInfo:nil repeats:NO];
        } else {
            
            CGRect frame = _viewIndefiniteProgress.frame;
            frame.origin.x = 0.0f;
            frame.size.width = CGRectGetWidth(self.frame);
            [_viewIndefiniteProgress setFrame:frame];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(onIndefiniteShrink) userInfo:nil repeats:NO];
        }
        
    } else if (indeterminate == NO) {
        _indeterminateState = indeterminate;
        [_viewIndefiniteProgress setFrame:CGRectMake(CGRectGetMidX(self.frame), 0.0f, 0.0f, CGRectGetHeight(self.frame))];
        
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Private

- (void)onTrickle {
    [self setProgress:(_progress + _trickleRate)];
    if (_progress >= 1.0f) {
        
        [_timer invalidate];
        _timer = nil;
        
        [self done];
    }
}

- (void)onIndefiniteGrow {
    CGRect frame = _viewIndefiniteProgress.frame;
    frame.origin.x = 0.0f;
    frame.size.width = CGRectGetWidth(self.frame);
    
    [UIView animateWithDuration:_animationTime animations:^{
        [_viewIndefiniteProgress setFrame:frame];
    } completion:^(BOOL finished) {
        [_timer invalidate];
        _timer = nil;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(onIndefiniteShrink) userInfo:nil repeats:NO];
    }];
}

- (void)onIndefiniteShrink {
    CGRect frame = _viewIndefiniteProgress.frame;
    frame.origin.x = (CGRectGetWidth(self.frame)/2.0f) - 10.0f;
    frame.size.width = 20.0f;
    
    [UIView animateWithDuration:_animationTime animations:^{
        [_viewIndefiniteProgress setFrame:frame];
    } completion:^(BOOL finished) {
        [_timer invalidate];
        _timer = nil;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(onIndefiniteGrow) userInfo:nil repeats:NO];
    }];
}

@end
