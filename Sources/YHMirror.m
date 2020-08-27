//
//  YHMirror.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirror.h"
#import "YHMirrorWindow.h"
#import "YHMirrorController.h"
#import "YHMirrorUI.h"
#import "YHSuspensionBall.h"

@interface YHMirror ()
/**
 * 主管理控制器
 */
@property (nonatomic, strong) YHMirrorController *mirrorController;

@end

@implementation YHMirror

static YHMirror *_mirror;
/**
 * 获取单利对象
 */
+ (instancetype)shareMirror {
    if (!_mirror) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _mirror = [[self alloc] init];
        });
    }
    return _mirror;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mirror = [super allocWithZone:zone];
    });
    return _mirror;
}

/**
 * 开启默认调试工具
 */
- (void)openDefaultMirror {
    [self.mirrorController openMirror:nil];
}

/**
 * 开启调试工具
 */
- (void)openMirror:(YHMirrorUI *)mirrorUI {
    [self.mirrorController openMirror:mirrorUI];
}
/**
 * 关闭调试工具
 */
- (void)closeMirror {
   [self.mirrorController closeMirror];
}

- (YHMirrorController *)mirrorController {
    if (!_mirrorController) {
        _mirrorController = [[YHMirrorController alloc]init];
    }
    return _mirrorController;
}


@end
