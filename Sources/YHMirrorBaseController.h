//
//  YHMirrorBaseController.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/25.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMirrorDebugTableView.h"
#import "YHMacro.h"

@interface YHMirrorBaseController : UIViewController
/**
 * view及superview 数据
 */
@property (nonatomic, strong) NSMutableArray *viewObjects;
/**
 * 类表数据
 */
@property (nonatomic, strong) YHMirrorDebugTableView *debugTableView;
/**
 * 目标视图
 */
@property (nonatomic, strong) UIView *targetView;
/**
 * 选中的对象
 */
@property (nonatomic, strong) id selectObject;

/**
 * 创建标题及退出按钮
 */
- (void)customNavigationItemTitle:(NSString *)title;

@end
