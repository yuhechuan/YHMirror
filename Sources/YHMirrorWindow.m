//
//  YHMirrorWindow.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorWindow.h"
@interface YHMirrorWindow ()

@end

@implementation YHMirrorWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // UITextEffectsWindow windowLevel 为10 为了UIMenuController 起作用
        self.windowLevel = 9;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 * 是否要相应 当前window上的事件
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = NO;
    if (self.pointInsideWindowMainControllerBlock) {
        if (self.pointInsideWindowMainControllerBlock(point)) {
            pointInside = [super pointInside:point withEvent:event];
        }
    }
    return pointInside;
}


@end
