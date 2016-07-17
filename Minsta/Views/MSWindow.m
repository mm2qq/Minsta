//
//  MSWindow.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSWindow.h"
#import "MinstaMacro.h"
#import "ZBJBPerformanceLabel.h"

@implementation MSWindow
{
@private
    UIView *_statusBar;
    ZBJBPerformanceLabel *_performanceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _statusBar = [UIView new];
        _statusBar.backgroundColor = MS_BAR_TINT_COLOR;

        [self addSubview:_statusBar];

        // 页面加入FPS Label以实时查看FPS
        // FIXME:仅供测试, 请及时注释掉该段代码
        // Modified by 毛朝龙
        // Date:2016/06/16
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.f, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        CGPoint originPoint = CGPointApplyAffineTransform(self.bounds.origin, transform);
        CGSize frameSize = _performanceLabel.frame.size;
        _performanceLabel = [ZBJBPerformanceLabel new];
        _performanceLabel.frame = (CGRect){originPoint, frameSize};
        [_performanceLabel sizeToFit];
        [self addSubview:_performanceLabel];
    }

    return self;
}

- (void)layoutSubviews {
    _statusBar.frame = (CGRect){CGPointZero, CGRectGetWidth(self.frame), CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)};

    [self bringSubviewToFront:_statusBar];
    [self bringSubviewToFront:_performanceLabel];
    [super layoutSubviews];
}

- (void)hideStatusBarOverlay:(BOOL)shouldHide {
    _statusBar.hidden = shouldHide;
    if (!shouldHide) [self bringSubviewToFront:_statusBar];
}

@end
