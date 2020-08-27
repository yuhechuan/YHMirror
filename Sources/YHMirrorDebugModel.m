//
//  YHMirrorDebugModel.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/25.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorDebugModel.h"

@implementation YHMirrorDebugItem

YHMirrorDebugItem *yh_createtField(NSString *value,
                                   YHTapContentBlock _Nullable tapValueAction) {
    return yh_createOptionsItem(nil, value, nil, nil, tapValueAction);
}

YHMirrorDebugItem *yh_createItem(NSString *field, NSString *value) {
    return yh_createOptionsItem(field, value, nil, nil, nil);
}

YHMirrorDebugItem *yh_createOptionsItem(NSString * field,
                                         NSString * value,
                                         UIColor * valueColor,
                                         UIFont * valueFont,
                                         YHTapContentBlock tapValueAction) {
    YHMirrorDebugItem *item = [[YHMirrorDebugItem alloc] init];
    item.field = field;
    item.value = value;
    item.valueColor = valueColor;
    item.valueFont = valueFont;
    item.tapValueAction = tapValueAction;
    return item;
}

@end

@implementation YHMirrorDebugSection

@end


