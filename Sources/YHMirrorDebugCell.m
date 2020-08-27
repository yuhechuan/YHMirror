//
//  YHMirrorDebugCell.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/26.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorDebugCell.h"
#import "YHMirrorDebugModel.h"
#import "YHMacro.h"

@interface YHMirrorDebugCell ()
/**
 * 属性控件
 */
@property (nonatomic, strong) UILabel *field;
/**
 * 属性内容控件
 */
@property (nonatomic, strong) UILabel *value;

@end

@implementation YHMirrorDebugCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

/**
 * 基础设置
 */
- (void)setUp {
    [self.contentView addSubview:self.field];
    [self.contentView addSubview:self.value];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
/**
 * 控件frame设置
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_item) {
        return;
    }
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    if (_item.field && _item.field.length > 0) {
        self.field.frame = CGRectMake(5, 0, 100, height);
    } else {
        self.field.frame = CGRectMake(5, 0, 0, height);
    }
    CGFloat x = CGRectGetMaxX(self.field.frame) + 5;
    self.value.frame = CGRectMake(x,0,width - x - 5, height);
}

/**
 * 模型赋值
 */
- (void)setItem:(YHMirrorDebugItem *)item {
    _item = item;
    self.field.text = item.field;
    self.value.text = item.value;
    self.contentView.backgroundColor = UIColor.clearColor;
    if (!item.valueColor) {
        self.value.textColor = UIColor.darkTextColor;
    }else{
        self.value.textColor = item.valueColor;
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        BOOL result = [item.valueColor getRed:&red green:&green blue:&blue alpha:&alpha];
        if (!result || (red >= 0.90 && green >= 0.90 && blue >= 0.90) || alpha < 0.1) {
            self.contentView.backgroundColor = [YH_THEME_COLOR colorWithAlphaComponent:0.4];
        }
    }
    if (item.valueFont) {
        self.value.font = item.valueFont;
    }else{
        self.value.font = [UIFont systemFontOfSize:15];
    }
    [self setNeedsLayout];
}


- (UILabel *)field {
    if (!_field) {
        _field = [[UILabel alloc]init];
        _field.font = [self PSCMediumFontSize:15];
        _field.textAlignment = NSTextAlignmentLeft;
        _field.numberOfLines = 0;
        _field.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    }
    return _field;
}

- (UILabel *)value {
    if (!_value) {
        _value = [[UILabel alloc]init];
        _value.font = [UIFont systemFontOfSize:15];
        _value.textAlignment = NSTextAlignmentLeft;
        _value.numberOfLines = 0;
    }
    return _value;
}

- (nonnull UIFont *)PSCMediumFontSize:(float)size {
    if (@available(iOS 9.0, *)) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
        if (font) {
            return font;
        }
    }
    return [UIFont boldSystemFontOfSize:size];
}

@end
