//
//  YHMirrorDebugTableView.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/26.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHMirrorDebugSection;

NS_ASSUME_NONNULL_BEGIN

@interface YHMirrorDebugTableView : UITableView
/**
 * 更新列表数据
 */
- (void)reloadWithModels:(NSArray <YHMirrorDebugSection *>*)models;

@end

NS_ASSUME_NONNULL_END
