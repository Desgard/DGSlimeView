# DGSlimeView

![img](/source/progress.gif)

模仿QQ消息提示的小红点动画，自己尝试的做了一下。之前参考过Kitten-yang的教程。

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


