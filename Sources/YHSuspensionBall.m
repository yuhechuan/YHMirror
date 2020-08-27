//
//  YHSuspensionBall.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHSuspensionBall.h"
#import "YHMacro.h"

@interface YHSuspensionBall ()
/**
 * 悬浮球里面标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 悬浮球配置项
 */
@property (nonatomic, strong) YHMirrorUI *mirrorUI;

@end

@implementation YHSuspensionBall

- (instancetype)initWithFrame:(CGRect)frame
                     mirrorUI:(YHMirrorUI *)mirrorUI {
    self = [super initWithFrame:frame];
    if (self) {
        _mirrorUI = mirrorUI;
        [self setUp];
    }
    return self;
}
/**
 * 基础配置
 */
- (void)setUp {
    self.userInteractionEnabled = YES;
    self.alpha = .7;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = self.frame.size.width <= self.frame.size.height ? self.frame.size.width / 2.0 : self.frame.size.height / 2.0;
    self.clipsToBounds = YES;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.delaysTouchesBegan = YES;
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    self.titleLabel.text = self.mirrorUI.ballText;
    self.backgroundColor = self.mirrorUI.ballColor;
}

/**
 * 拖动手势
 */
- (void)panAction:(UIPanGestureRecognizer *)p {
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
    }else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        self.alpha = .7;
        
        CGFloat ballWidth = self.frame.size.width;
        CGFloat ballHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        
        CGFloat minSpace = 0;
        if (self.mirrorUI.ballType == YHMirrorSuspensionBallTypeHorizontal) {
            minSpace = MIN(left, right);
        }else{
            minSpace = MIN(MIN(MIN(top, left), bottom), right);
        }
        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        //Correcting Y
        if (panPoint.y < self.mirrorUI.edgeMarginV) {
            targetY = self.mirrorUI.edgeMarginV;
        } else if (panPoint.y > (screenHeight - ballHeight - self.mirrorUI.edgeMarginV)) {
            targetY = screenHeight - ballHeight - self.mirrorUI.edgeMarginV;
        } else {
            targetY = panPoint.y;
        }
        
        CGFloat centerXSpace =  self.mirrorUI.edgeMarginH;
        CGFloat centerYSpace =  self.mirrorUI.edgeMarginV;

        if (minSpace == left) {
            newCenter = CGPointMake(ballWidth / 2.0 + centerXSpace, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - (ballWidth / 2.0 + centerXSpace), targetY);
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, YHIPhoneXTop + centerYSpace + ballHeight/ 2.0);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - YHIphoneXBottom - centerYSpace - ballHeight/ 2.0);
        }
        
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        }];
    }else{
        NSLog(@"pan state : %zd", p.state);
    }
}
/**
 * 点击手势
 */
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.didClickSuspensionBall) {
        self.didClickSuspensionBall();
    }
}
/**
 * 获取字体
 */
- (nonnull UIFont *)PSCFontSize:(float)size {
    if (@available(iOS 9.0, *)) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
        if (font) {
            return font;
        }
    }
    return [UIFont systemFontOfSize:size];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.font = [self PSCFontSize:14];
        _titleLabel.textColor = self.mirrorUI.ballTextColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
