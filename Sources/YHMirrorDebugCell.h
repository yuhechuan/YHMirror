//
//  YHMirrorDebugCell.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/26.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YHMirrorDebugItem;

@interface YHMirrorDebugCell : UITableViewCell
/**
 * 数据模型
 */
@property (nonatomic, strong) YHMirrorDebugItem *item;

@end

NS_ASSUME_NONNULL_END
