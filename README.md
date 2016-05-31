# DGSlimeView

![Platforms](https://cocoapod-badges.herokuapp.com/p/MZTimerLabel/badge.png)

1. 拖拽时的藕断丝连动画的实现思路可以看我的博文[QQ Message Bubble's Coppy - DGSlimeView](http://desgard.com/2016/05/28/DGSlimeView/)
2. 粒子爆炸效果动画实现思路[Particle Explosion Effect](http://desgard.com/2016/05/30/DGSlimeView-Boom/)

<img src="/source/progress.gif" alt="img" width="300px">

模仿QQ消息提示的小红点动画，自己尝试的做了一下。之前参考过Kitten-yang的教程。

## 藕断丝连主要思路

下面是贝塞尔曲线绘制的核心方法。这张图也是DGSlimeView主要数学思路。

![img](/source/source1.png)

对应在代码中，贝塞尔曲线实现方法：

```Objective-C
#pragma mark - 绘制贝塞尔图形
- (void) reloadBeziePath {
    CGFloat r1 = self.trailDot.frame.size.width / 2.0f;
    CGFloat r2 = self.headDot.frame.size.width / 2.0f;
    
    CGFloat x1 = self.trailDot.center.x;
    CGFloat y1 = self.trailDot.center.y;
    CGFloat x2 = self.headDot.center.x;
    CGFloat y2 = self.headDot.center.y;
    
    CGFloat distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    
    CGFloat sinDegree = (x2 - x1) / distance;
    CGFloat cosDegree = (y2 - y1) / distance;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosDegree, y1 + r1 * sinDegree);
    CGPoint pointB = CGPointMake(x1 + r1 * cosDegree, y1 - r1 * sinDegree);
    CGPoint pointC = CGPointMake(x2 + r2 * cosDegree, y2 - r2 * sinDegree);
    CGPoint pointD = CGPointMake(x2 - r2 * cosDegree, y2 + r2 * sinDegree);
    CGPoint pointN = CGPointMake(pointB.x + (distance / 2) * sinDegree, pointB.y + (distance / 2) * cosDegree);
    CGPoint pointM = CGPointMake(pointA.x + (distance / 2) * sinDegree, pointA.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: pointA];
    [path addLineToPoint: pointB];
    [path addQuadCurveToPoint: pointC controlPoint: pointN];
    [path addLineToPoint: pointD];
    [path addQuadCurveToPoint: pointA controlPoint: pointM];
    
    self.shapLayer.path = path.CGPath;
}
```

## 粒子爆照主要思路

先对View进行例子分割，将各个粒子在view的layer上进行绘制，用数组保存每个粒子的layer。

![img](/source/source2.jpeg)

```Objective-C
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
```

然后再绘制贝塞尔曲线，实现各个粒子下落状态。由于是模拟爆炸效果，所以缓动函数选用`kCAMediaTimingFunctionEaseOut`。

```Objective-C
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
```
