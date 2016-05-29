//
//  DGSlimeDotView.m
//  DGSlimeView
//
//  Created by 段昊宇 on 16/5/29.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGSlimeDotView.h"
#import "CommonHeader.h"

@implementation DGSlimeDotView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = DGThemeColor;
        self.clipsToBounds = YES;
    }
    return self;
}


- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = CGRectGetWidth(frame) / 2.f;
}
@end
