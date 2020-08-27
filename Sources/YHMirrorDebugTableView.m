//
//  YHMirrorDebugTableView.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/26.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorDebugTableView.h"
#import "YHMirrorDebugModel.h"
#import "YHMirrorDebugCell.h"
#import "YHMacro.h"
#import <objc/runtime.h>

#define DEBUG_DEFAULT_ROW_HEIGHT 56

static char const * kAssociateCellHeightKey = "kAssociateCellHeightKey";

@interface YHMirrorDebugTableView ()<UITableViewDelegate, UITableViewDataSource>
/**
 * 数据源
 */
@property (nonatomic, strong) NSArray <YHMirrorDebugSection *>*debugModels;
/**
 * 默认cell高度
 */
@property (nonatomic, assign) CGFloat defaultRowHeight;

@end

@implementation YHMirrorDebugTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setUp];
    }
    return self;
}
/**
 * 基础设置
 */
- (void)setUp {
    //overview tableView
    self.defaultRowHeight = DEBUG_DEFAULT_ROW_HEIGHT;
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    self.sectionHeaderHeight = 28;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[YHMirrorDebugCell class] forCellReuseIdentifier:NSStringFromClass([YHMirrorDebugCell class])];
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,YH_SCREEN_WIDTH , YHIphoneXBottom)];
}
/**
 * 更新数据
 */
- (void)reloadWithModels:(NSArray <YHMirrorDebugSection *>*)models {
    if (!models) {
        return;
    }
    self.debugModels = models;
    [self reloadData];
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.debugModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.debugModels.count) {
        return 0;
    }
    YHMirrorDebugSection *debug = self.debugModels[section];
    return debug.sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.debugModels.count) {
        return [UITableViewCell new];
    }
    YHMirrorDebugSection *debug = self.debugModels[indexPath.section];
    if (indexPath.row >= debug.sectionItems.count) {
        [UITableViewCell new];
    }
    YHMirrorDebugItem *item = debug.sectionItems[indexPath.row];
    YHMirrorDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YHMirrorDebugCell class]) forIndexPath:indexPath];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.debugModels.count) {
        return 0;
    }
    YHMirrorDebugSection *debug = self.debugModels[indexPath.section];
    if (indexPath.row >= debug.sectionItems.count) {
        return 0;
    }
    YHMirrorDebugItem *item = debug.sectionItems[indexPath.row];
    CGFloat height = [objc_getAssociatedObject(item, kAssociateCellHeightKey) floatValue];
    return height > self.defaultRowHeight ? height : self.defaultRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= self.debugModels.count) {
        return [UIView new];
    }
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YH_SCREEN_WIDTH, 28)];
    back.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, YH_SCREEN_WIDTH - 8, 28)];
    headerLabel.textColor = [UIColor colorWithRed:83/255.0 green:139/255.0 blue:6/255.0 alpha:1];;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.backgroundColor = [UIColor clearColor];
    [back addSubview:headerLabel];
    YHMirrorDebugSection *debug = self.debugModels[section];
    headerLabel.text = debug.sectionTitle;
    return back;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= self.debugModels.count) {
        return;
    }
    YHMirrorDebugSection *debug = self.debugModels[indexPath.section];
    if (indexPath.row >= debug.sectionItems.count) {
        return;
    }
    YHMirrorDebugItem *item = debug.sectionItems[indexPath.row];
    if (item.tapValueAction) {
        item.tapValueAction();
        return;
    }
    
    BOOL needReload = NO;
    CGFloat height = [objc_getAssociatedObject(item, kAssociateCellHeightKey) floatValue];
    if (height > self.defaultRowHeight) {
       height = self.defaultRowHeight;
       needReload = YES;
    }else{
       height = [self getItemHeightWith:item];
       if (height > self.defaultRowHeight) {
           needReload = YES;
       }
    }
    if (needReload) {
       objc_setAssociatedObject(item, kAssociateCellHeightKey, @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
/**
 * 算出value的高度
 */
- (CGFloat)getItemHeightWith:(YHMirrorDebugItem *)item {
    if(!item.value) return 0;
    CGSize size = CGSizeMake(YH_SCREEN_WIDTH - 100 - 15, CGFLOAT_MAX);
    if (!item.field) {
        size = CGSizeMake(YH_SCREEN_WIDTH - 10, CGFLOAT_MAX);
    }
    CGRect rect = [item.value boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    return ceil(rect.size.height) + 1;
}


@end
