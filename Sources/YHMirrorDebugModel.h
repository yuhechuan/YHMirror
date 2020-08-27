//
//  YHMirrorDebugModel.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/25.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YHTapContentBlock)(void);

@interface YHMirrorDebugItem : NSObject
/**
 * 属性名称
 */
@property(nonatomic, copy, nullable) NSString *field;
/**
 * 属性值
 */
@property(nonatomic, copy, nullable) NSString *value;
/**
 * 属性颜色
 */
@property(nonatomic, strong, nullable) UIColor *valueColor;
/**
 * 属性字体
 */
@property(nonatomic, strong, nullable) UIFont * valueFont;
/**
 * 当前属性点击事件
 */
@property(nonatomic, copy, nullable) YHTapContentBlock tapValueAction;

/**
 * 通过value 构建一个item
 */
extern
YHMirrorDebugItem * _Nonnull yh_createtField(NSString * _Nullable value,
                                             YHTapContentBlock _Nullable tapValueAction);
/**
 * 通过field value 构建一个item
 */
extern
YHMirrorDebugItem * _Nonnull yh_createItem(NSString * _Nullable field,
                                          NSString * _Nullable value);
/**
 * 构建一个item
 */
extern
YHMirrorDebugItem * _Nonnull yh_createOptionsItem(NSString * _Nullable field,
                                                 NSString * _Nullable value,
                                                 UIColor * _Nullable valueColor,
                                                 UIFont * _Nullable valueFont,
                                                 YHTapContentBlock _Nullable tapValueAction);

@end

@interface YHMirrorDebugSection : NSObject
/**
 * 分组标题
 */
@property (nonatomic, copy) NSString *sectionTitle;
/**
 * 分组内容列表
 */
@property (nonatomic, strong) NSArray <YHMirrorDebugItem *> *sectionItems;

@end


NS_ASSUME_NONNULL_END
