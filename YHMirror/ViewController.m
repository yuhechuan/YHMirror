//
//  ViewController.m
//  YHMirror
//
//  Created by yuhechuan on 2020/8/27.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "ViewController.h"
#import "YHButton.h"

@interface ViewController ()

@property (nonatomic, strong) YHButton *display;
@property (nonatomic, strong) YHButton *displayPresent;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
}

- (void)setUp {
    self.title = @"项目演示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 200;
    CGFloat height = 50;
    CGFloat x = (self.view.bounds.size.width - width) / 2.0;
    CGFloat y1 = 200;
    _display = [[YHButton alloc]initWithFrame:CGRectMake(x, y1, width, height)];
    _display.title = @"我是第一个按钮";
    _display.buttonColor = [UIColor colorWithRed:70 / 225.0 green:187 / 255.0 blue:38 / 255.0 alpha:1];
    typeof(self) __weak weakSelf = self;
    _display.operation = ^{
        [weakSelf displayAnimation];
    };
    [self.view addSubview:_display];
    
    _displayPresent = [[YHButton alloc]initWithFrame:CGRectMake(x, y1+ height *2, width, height)];
    _displayPresent.title = @"我是第二个按钮";
    _displayPresent.buttonColor = [UIColor colorWithRed:230 / 225.0 green:103 / 255.0 blue:103 / 255.0 alpha:1];
    _displayPresent.operation = ^{
        [weakSelf displayAnimationPresent];
    };
    [self.view addSubview:_displayPresent];
}

- (void)displayAnimation {
    [self showAlert:UIAlertControllerStyleActionSheet];
}

- (void)displayAnimationPresent {
    [self showAlert:UIAlertControllerStyleAlert];
}

- (void)showAlert:(UIAlertControllerStyle)style {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在自己复杂的工程体验本功能,点击悬浮球之后,屏幕上方会有提示问题!" preferredStyle:style];
    //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction

    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //添加确定
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
    }];
    //设置`确定`按钮的颜色
    //将action添加到控制器
    [alertVc addAction:cancelBtn];
    [alertVc addAction :sureBtn];
    //展示
    [self presentViewController:alertVc animated:YES completion:nil];
}

@end
