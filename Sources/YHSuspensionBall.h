//
//  YHSuspensionBall.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMirrorUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHSuspensionBall : UIView
/**
 * 点击回调
 */
@property (nonatomic, copy) void (^didClickSuspensionBall)(void);
/**
 * 通过配置YHMirrorUI 
 */
- (instancetype)initWithFrame:(CGRect)frame
                     mirrorUI:(YHMirrorUI *)mirrorUI;

@end

NS_ASSUME_NONNULL_END
