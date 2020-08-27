//
//  YHMirror.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHMirrorUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHMirror : NSObject
/**
 * 获取单利对象
 */
+ (instancetype)shareMirror;
/**
 * 开启默认的调试工具
 */
- (void)openDefaultMirror;
/**
 * 开启调试工具
 */
- (void)openMirror:(YHMirrorUI *)mirrorUI;

/**
 * 关闭调试工具
 */
- (void)closeMirror;

@end

NS_ASSUME_NONNULL_END
