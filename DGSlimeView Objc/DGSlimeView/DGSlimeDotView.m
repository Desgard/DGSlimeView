//
//  DGSlimeDotView.m
//  DGSlimeView
//
//  Created by 段昊宇 on 16/5/29.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGSlimeDotView.h"
#import "CommonHeader.h"
#import "UIImage+DGSlimeBoom.h"
#import "UIView+DGSlimeBoom.h"

@interface DGSlimeDotView()

@property (nonatomic, strong) NSMutableArray<CALayer *> *boomCells;
@property (nonatomic, strong) UIImage *scaleSnapshot;

@property (nonatomic) CGPoint origin;

@end

@implementation DGSlimeDotView


#pragma mark - override
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = DGThemeColor;
        self.clipsToBounds = YES;
        self.boomCells = [[NSMutableArray<CALayer *> alloc] init];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = CGRectGetWidth(frame) / 2.f;
}


#pragma mark - public方法

#pragma mark - 进入动画
- (void) boom: (CGPoint) point {
    self.backgroundColor = self.superview.backgroundColor;
    self.origin = point;
    for (int i = 0; i < 8; ++ i) {
        for (int j = 0; j < 8; ++ j) {
            CGFloat pw = MIN(self.frame.size.width, self.frame.size.height) / 8.f;
            CALayer *shape = [[CALayer alloc] init];
            shape.backgroundColor = DGThemeColor.CGColor;
            shape.cornerRadius = pw / 2;
            shape.frame = CGRectMake(i * pw, j * pw, pw, pw);
            [self.layer.superlayer addSublayer: shape];
            [self.boomCells addObject: shape];
        }
    }
    
    [self cellAnimation];
    
}

#pragma mark - 粒子动画
- (void) cellAnimation {
    for (CALayer *shape in self.boomCells) {
        CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath: @"position"];
        ani.path = [self makeRandomPath: shape].CGPath;
        ani.fillMode = kCAFillModeForwards;
        ani.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        ani.duration = 3;
        ani.removedOnCompletion = NO;
        [shape addAnimation: ani forKey: @"moveAnimation"];
    }
}

#pragma mark - 震动效果
- (void) shakeAnimations {
    CAKeyframeAnimation *shakeXAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position.x"];
    shakeXAnimation.duration = 0.2;
    shakeXAnimation.values = [NSArray arrayWithObjects:
                              [[NSNumber alloc] initWithFloat: [self makeShakeValue: self.layer.position.x]],
                              [[NSNumber alloc] initWithFloat: [self makeShakeValue: self.layer.position.x]],
                              [[NSNumber alloc] initWithFloat: [self makeShakeValue: self.layer.position.x]], nil];
    
    CAKeyframeAnimation *shakeYAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position.y"];
    shakeYAnimation.duration = 0.2;
    shakeYAnimation.values = [NSArray arrayWithObjects:
                              [[NSNumber alloc] initWithFloat: [self makeShakeValue: self.layer.position.y]],
                              [[NSNumber alloc] initWithFloat: [self makeShakeValue: self.layer.position.y]],
                              [[NSNumber alloc] initWithFloat: [self makeShakeValue: self.layer.position.y]], nil];
    
    [self.layer addAnimation: shakeXAnimation forKey: @"shakeXAnimation"];
    [self.layer addAnimation: shakeYAnimation forKey: @"shakeYAnimation"];
}

#pragma mark - 缩放透明度动画
- (void) scaleOpacityAnimations {
    // 缩放
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    scaleAnimation.toValue = @0.01;
    scaleAnimation.duration = 0.15;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    // 透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    opacityAnimation.duration = 0.15;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation: scaleAnimation forKey: @"lscale"];
    [self.layer addAnimation: opacityAnimation forKey: @"lopacity"];
    self.layer.opacity = 0;
}

#pragma mark - 随机曲线路径
- (UIBezierPath *) makeRandomPath: (CALayer *) alayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat delta = self.frame.size.width / 2;
    CGPoint po = CGPointMake(self.origin.x + alayer.position.x - delta, self.origin.y + alayer.position.y - delta);
    [path moveToPoint: po];
    
    CGPoint pod = CGPointMake(self.superview.center.x, self.superview.frame.size.height * 4);
    long widL = [UIScreen mainScreen].bounds.size.width;
    long heiL = [UIScreen mainScreen].bounds.size.height;
    [path addQuadCurveToPoint: pod controlPoint:CGPointMake((random() % widL), random() % heiL)];
    return path;
}

#pragma mark - 随机产生震动值
- (CGFloat) makeShakeValue: (CGFloat) val {
    CGFloat basicOrigin = 10.f;
    CGFloat maxOffset = -2 * basicOrigin;
    CGFloat result = basicOrigin + maxOffset * (random() % 30) / 100.f + val;
    return result;
}


@end
