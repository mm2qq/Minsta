//
//  MSWindow.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSWindow.h"
#import "MinstaMacro.h"

@implementation MSWindow
{
@private
    UIView *_statusBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _statusBar                 = [UIView new];
        _statusBar.backgroundColor = MS_BAR_TINT_COLOR;
        [self addSubview:_statusBar];
    }

    return self;
}

- (void)layoutSubviews {
    _statusBar.frame = (CGRect){CGPointZero, CGRectGetWidth(self.frame), CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)};

    [self bringSubviewToFront:_statusBar];
    [super layoutSubviews];
}

@end
