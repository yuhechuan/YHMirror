//
//  YHMirrorUI.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHMirrorSuspensionBallType) {
    YHMirrorSuspensionBallTypeEachSide = 0, // 四边判断距离进行靠近
    YHMirrorSuspensionBallTypeHorizontal,   // 左右进行靠近
};
/**
 * 配置文件
 */
@interface YHMirrorUI : NSObject
/**
 * 悬浮球 文字 默认是调试
 */
@property (nonatomic, copy) NSString *ballText;
/**
 * 悬浮球 文字颜色 默认是 [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *ballTextColor;
/**
 * 悬浮球 背景颜色 默认是 [UIColor colorWithRed:30/225.0 green:144/255.0 blue:255 /255.0 alpha:1.00];
 */
@property (nonatomic, strong) UIColor *ballColor;
/**
 * 自定义视图
 */
@property (nonatomic, strong) UIView *customBallView;
/**
 * 悬浮球停留在屏幕上下边距 默认是 20 已经适配iPhone X
 */
@property (nonatomic, assign) CGFloat edgeMarginV;
/**
 * 悬浮球停留在屏幕左右边距 默认是 5
 */
@property (nonatomic, assign) CGFloat edgeMarginH;
/**
 * 悬浮球首次出现的位置 x
 */
@property (nonatomic, assign) CGFloat ballDefaultX;
/**
 * 悬浮球首次出现的位置 y
 */
@property (nonatomic, assign) CGFloat ballDefaultY;
/**
 * 悬浮球的大小 默认是CGSizeMake(60, 60);
 */
@property (nonatomic, assign) CGSize ballSize;
/**
 * 悬浮球类型  默认是 四个边都可停留
 */
@property (nonatomic, assign) YHMirrorSuspensionBallType ballType;
/**
 * 默认配置
 */
+ (YHMirrorUI *)defaultMirrorUI;

@end

NS_ASSUME_NONNULL_END
