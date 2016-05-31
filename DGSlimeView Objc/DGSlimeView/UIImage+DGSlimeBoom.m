//
//  UIImage+DGSlimeBoom.m
//  DGSlimeView
//
//  Created by 段昊宇 on 16/5/30.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "UIImage+DGSlimeBoom.h"

@implementation UIImage(DGSlimeBoom)

#pragma mark - 图片缩放
- (UIImage *) scaleImageToSize: (CGSize) size View: (UIView *) dadview {
    UIGraphicsBeginImageContext(size);
    [dadview drawRect: CGRectMake(0, 0, size.width, size.height)];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}


@end
