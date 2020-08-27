//
//  YHMirrorUI.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorUI.h"

@implementation YHMirrorUI

+ (YHMirrorUI *)defaultMirrorUI {
    YHMirrorUI *u = [[YHMirrorUI alloc]init];
    u.ballColor = [UIColor colorWithRed:30/225.0 green:144/255.0 blue:255 /255.0 alpha:1.00];
    u.ballText = @"调试";
    u.edgeMarginH = 5;
    u.edgeMarginV = 20;
    u.ballTextColor = [UIColor whiteColor];
    u.ballType = YHMirrorSuspensionBallTypeEachSide;
    u.ballSize = CGSizeMake(60, 60);
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    u.ballDefaultX = screenWidth - u.ballSize.width;
    u.ballDefaultY = 80;
    return u;
}

@end

