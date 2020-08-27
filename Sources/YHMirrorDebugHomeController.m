//
//  YHMirrorDebugHomeController.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/25.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorDebugHomeController.h"
#import "YHMirrorDebugModel.h"
#import "YHMirrorDebugDetailController.h"

@interface YHMirrorDebugHomeController ()

@end

@implementation YHMirrorDebugHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
    [self loadData];
}
/**
 * view设置
 */
- (void)setUp {
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNavigationItemTitle:@"View Hierarchy"];
}

/**
 * 组装数据
 */
- (void)loadData {
    // 数据item数据
    UIView *currentView = self.targetView;
    BOOL needBreak = NO;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    while (currentView) {
        id select = currentView;
        NSString *format = [NSString stringWithFormat:@"(%@ *)%p",NSStringFromClass([select class]),select];
        [items addObject:yh_createtField(format, ^{
            [weakSelf pushToDebugDetailPage:select];
        })];
        if (needBreak) break;
        if ([currentView.nextResponder isKindOfClass:UIViewController.class]) {
           needBreak = YES;
        }
        currentView = currentView.superview;
    }
    
    // 创建组
    YHMirrorDebugSection *section = [[YHMirrorDebugSection alloc]init];
    section.sectionTitle = @"Path Views";
    section.sectionItems = items.copy;
    [self.debugTableView reloadWithModels:@[section]];
}

/**
 * 点击查看详情
 */
- (void)pushToDebugDetailPage:(id)selectObject {
    YHMirrorDebugDetailController *d = [[YHMirrorDebugDetailController alloc]init];
    d.selectObject = selectObject;
    [self.navigationController pushViewController:d animated:YES];
}

@end
