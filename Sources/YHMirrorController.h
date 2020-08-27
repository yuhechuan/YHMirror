//
//  YHMirrorController.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHMirrorUI;

@interface YHMirrorController : UIViewController
/**
 * 开启调试悬浮球 可自定义显示 样式
 */
- (void)openMirror:(YHMirrorUI *)mirrorUI;
/**
 * 关闭悬浮球
 */
- (void)closeMirror;

@end
