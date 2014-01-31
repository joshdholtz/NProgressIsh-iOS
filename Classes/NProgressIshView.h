//
//  NProgressIshView.h
//  NProgressIsh
//
//  Created by Josh Holtz on 1/31/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NProgressIshView : UIView

@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float animationTime;

- (void)start;
- (void)done;

@end
