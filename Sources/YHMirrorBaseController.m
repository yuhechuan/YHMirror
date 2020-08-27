//
//  YHMirrorBaseController.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/25.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorBaseController.h"


@interface YHMirrorBaseController ()

@end

@implementation YHMirrorBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.view addSubview:self.debugTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)customNavigationItemTitle:(NSString *)title  {
    //title view
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(dissmissAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    // 如果不传title 不创建titleview
    if (!title || title.length == 0) {
        return;
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
}

- (void)dissmissAction {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSMutableArray *)viewObjects {
    if (!_viewObjects) {
        _viewObjects = [NSMutableArray array];
    }
    return _viewObjects;
}

- (YHMirrorDebugTableView *)debugTableView {
    if (!_debugTableView) {
        CGRect frame = CGRectMake(0, 0,YH_SCREEN_WIDTH , YH_SCREEN_HEIGHT - YH_NAVHEIGHT);
        _debugTableView = [[YHMirrorDebugTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    }
    return _debugTableView;
}

@end
