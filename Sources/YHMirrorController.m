//
//  YHMirrorController.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorController.h"
#import "YHMirrorTreeView.h"
#import "YHSuspensionBall.h"
#import "YHMirrorWindow.h"
#import "YHMirrorDebugHomeController.h"
#import "YHMirrorNavigationController.h"
#import "YHMirrorDebugDetailController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YHMirrorController ()

@property (nonatomic, strong) YHMirrorTreeView *mirrorTreeView;
@property (nonatomic, strong) UIWindow *userKeyWindow;
@property (nonatomic, strong) YHMirrorWindow *suspensionWindow;
@property (nonatomic, strong) YHSuspensionBall *suspensionBall;
@property (nonatomic, strong) YHMirrorUI *customMirrorUI;
@property (nonatomic, strong) UILabel *hintDebugView;

@end

@implementation YHMirrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userKeyWindow = [UIApplication sharedApplication].keyWindow;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeWindow:) name:UIWindowDidBecomeKeyNotification object:nil];
}

- (void)openMirror:(YHMirrorUI *)mirrorUI {
    self.customMirrorUI = mirrorUI;
    [self.suspensionWindow setHidden:NO];
    [self.view bringSubviewToFront:self.suspensionBall];
}

- (void)closeMirror {
    self.suspensionWindow.hidden = YES;
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    self.suspensionWindow.rootViewController = nil;
}

- (void)displayToolMenu {
    // 添加震动 普通短震，3D Touch 中 Peek 震动反馈
    AudioServicesPlaySystemSound(1519);
    if (self.mirrorTreeView.hidden) {
        self.mirrorTreeView.hidden = NO;
        self.hintDebugView.hidden = NO;
        [self.mirrorTreeView updateCurrentKeyWindow:self.userKeyWindow];
        [self makeMirrorWindowBecomeKeyWindow];
        [self.view bringSubviewToFront:self.suspensionBall];
    } else {
        self.mirrorTreeView.hidden = YES;
        self.hintDebugView.hidden = YES;
        [self makeUserWindowBecomeKeyWindow];
    }
}

- (void)makeMirrorWindowBecomeKeyWindow {
    [self.view.window makeKeyWindow];
}

- (void)makeUserWindowBecomeKeyWindow {
    if (!self.userKeyWindow.keyWindow) {
        [self.userKeyWindow makeKeyWindow];
    }
}

/**
 * 当window发生改变时
 */
- (void)didBecomeWindow:(NSNotification *)notfication {
    
    BOOL isMirrorWindow = [notfication.object isKindOfClass:NSClassFromString(@"YHMirrorWindow")];
    //Save the user's key window object.
    if ([notfication.object isMemberOfClass:UIWindow.class]) {
        self.userKeyWindow = notfication.object;
        
    }else if (!isMirrorWindow && ![NSStringFromClass([notfication.object class]) hasPrefix:@"_UI"]) {
        self.userKeyWindow = notfication.object;
    }
}

- (BOOL)shouldReveiveEventInWindowPoint:(CGPoint)point {
    BOOL shouldReveiveEvent = !self.mirrorTreeView.hidden;
    CGPoint pointInLocalCoordinate = [self.view convertPoint:point fromView:nil];
    if (CGRectContainsPoint(self.suspensionBall.frame, pointInLocalCoordinate)) {
       shouldReveiveEvent = YES;
    }
    return shouldReveiveEvent;
}

- (YHMirrorNavigationController *)navigationWithRootVC:(UIViewController *)rootVC {
    YHMirrorNavigationController* navTool = [[YHMirrorNavigationController alloc] initWithRootViewController:rootVC];
    return navTool;
}

- (YHMirrorTreeView *)mirrorTreeView {
    if (!_mirrorTreeView) {
        _mirrorTreeView = [[YHMirrorTreeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _mirrorTreeView.hidden = YES;
        _mirrorTreeView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _mirrorTreeView.indexBlock = ^(UIView * _Nonnull selectView, int index) {
            YHMirrorBaseController *vc = nil;
            if (index == 0) {
                vc = [[YHMirrorDebugDetailController alloc]init];
                vc.selectObject = selectView;
            } else {
                vc = [[YHMirrorDebugHomeController alloc]init];
                vc.targetView = selectView;
            }
            [weakSelf presentViewController:[weakSelf navigationWithRootVC:vc] animated:YES completion:nil];
        };
        [self.view addSubview:_mirrorTreeView];
    }
    return _mirrorTreeView;
}

- (YHMirrorWindow *)suspensionWindow {
    if (!_suspensionWindow) {
        _suspensionWindow = [[YHMirrorWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _suspensionWindow.rootViewController = self;
        __weak typeof(self) weakSelf = self;
        _suspensionWindow.pointInsideWindowMainControllerBlock = ^BOOL(CGPoint point) {
            return [weakSelf shouldReveiveEventInWindowPoint:point];
        };
    }
    return _suspensionWindow;;
}

- (YHSuspensionBall *)suspensionBall {
    if (!_suspensionBall) {
        YHMirrorUI *mirrorUI = self.customMirrorUI ?:[YHMirrorUI defaultMirrorUI];
        CGRect frame = CGRectMake(mirrorUI.ballDefaultX, mirrorUI.ballDefaultY, mirrorUI.ballSize.width,  mirrorUI.ballSize.height);
        _suspensionBall = [[YHSuspensionBall alloc]initWithFrame:frame
                                                        mirrorUI:mirrorUI];
        // 点击那妞
        __weak typeof(self) weakSelf = self;
        _suspensionBall.didClickSuspensionBall = ^{
            [weakSelf displayToolMenu];
        };
        [self.view addSubview:_suspensionBall];
    }
    return _suspensionBall;
    
}

- (UILabel *)hintDebugView {
    if (!_hintDebugView) {
        CGFloat width = YH_SCREEN_WIDTH / 3.0;
        _hintDebugView = [[UILabel alloc]initWithFrame:CGRectMake(width, YHIPhoneXTop + 10 , width, 20)];
        _hintDebugView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _hintDebugView.textColor = [UIColor whiteColor];
        _hintDebugView.text = @"请点击要调试的视图";
        _hintDebugView.textAlignment = NSTextAlignmentCenter;
        _hintDebugView.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:_hintDebugView];
    }
    return _hintDebugView;
}


@end
