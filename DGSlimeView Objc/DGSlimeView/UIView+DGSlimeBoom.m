//
//  UIView+DGSlimeBoom.m
//  DGSlimeView
//
//  Created by 段昊宇 on 16/5/30.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "UIView+DGSlimeBoom.h"

@implementation UIView(DGSlimeBoom)

#pragma mark - 获取快照
- (UIImage *) snapshot {
    UIGraphicsBeginImageContext(self.layer.frame.size);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
