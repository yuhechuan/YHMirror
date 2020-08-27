//
//  YHMirrorTreeView.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorTreeView.h"

@interface YHMirrorTreeView ()<UIGestureRecognizerDelegate>
/**
 * 点击手势来 款选视图
 */
@property (nonatomic, strong) UITapGestureRecognizer *viewsLevelGesture;
/**
 * 当前框选的view数组
 */
@property (nonatomic, strong) NSMutableArray *currentTapOutlineViews;
/**
 * 单前选中的view
 */
@property (nonatomic, strong) UIView *currentSelectView;
/**
 * 用户window
 */
@property (nonatomic, strong) UIWindow *userKeyWindow;

@end

@implementation YHMirrorTreeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
/**
 * 基础设置
 */
- (void)setUp {
    //views level
    self.viewsLevelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewsLevel:)];
    self.viewsLevelGesture.delegate = self;
    [self addGestureRecognizer:self.viewsLevelGesture];
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}
/**
 * 更改用户window
 */
- (void)updateCurrentKeyWindow:(UIWindow *)userKeyWindow {
    self.userKeyWindow = userKeyWindow;
    [self clearAllOutlineViews];
}

/**
 * 点击事件处理 生成框
 */
- (void)handleTapViewsLevel:(UITapGestureRecognizer *)tapGesture {
    [self clearAllOutlineViews];
    if (tapGesture.state != UIGestureRecognizerStateEnded) return;
    
    CGPoint point = [tapGesture locationInView:self];
    NSArray *containTapPointViews = [self recursiveSubviewsAtPoint:point inView:self.userKeyWindow skipHiddenViews:YES];
    self.currentSelectView = [containTapPointViews lastObject];
    
    NSMutableArray *outlineViews = [[NSMutableArray alloc] init];
    CGRect menuRect = self.frame;
    for (UIView *view in containTapPointViews) {
        CGRect realRect = [view convertRect:view.bounds toView:self];
        UIView *outlineV = [[UIView alloc] initWithFrame:realRect];
        outlineV.userInteractionEnabled = NO;
        //outline color
        CGFloat hue = (1 + (arc4random() % 9))/10.;
        UIColor *outlineColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
        outlineV.layer.borderColor = outlineColor.CGColor;
        outlineV.layer.borderWidth = 1.3;
        if (view == self.currentSelectView) {
            outlineV.backgroundColor = [outlineColor colorWithAlphaComponent:0.15];
            menuRect= realRect;
        }else{
            outlineV.backgroundColor = [UIColor clearColor];
        }
        [self addSubview:outlineV];
        [outlineViews addObject:outlineV];
    }
    self.currentTapOutlineViews = outlineViews;
    [self showMenu:menuRect];
}

/**
 * 显示menu
 */
- (void)showMenu:(CGRect)menuRect {
    UIMenuController * menu = [UIMenuController sharedMenuController];
    NSLog(@"%d",menu.isMenuVisible);
    //防止点击多次创建
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    [self becomeFirstResponder];

    UIMenuItem * item0 = [[UIMenuItem alloc]initWithTitle:NSStringFromClass([self.currentSelectView class]) action:@selector(targetDetailAction)];
    UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"Views" action:@selector(targetViewsAction)];
    menu.menuItems = @[item0,item1];

    [menu setTargetRect:CGRectMake(menuRect.origin.x, menuRect.origin.y, menuRect.size.width, menuRect.size.height) inView:self];
    [menu setMenuVisible:YES animated:YES];
}
/**
 * UIMenuItem 需要返回的 代理
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(targetDetailAction) ||
        action == @selector(targetViewsAction)) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
/**
 * 获取点击视图素有 有效父视图数组
 */
- (NSArray *)recursiveSubviewsAtPoint:(CGPoint)pointInView inView:(UIView *)view skipHiddenViews:(BOOL)skipHidden {
    NSMutableArray *subviewsAtPoint = [[NSMutableArray alloc] init];
    for (UIView *subview in view.subviews) {
        BOOL isHidden = subview.hidden || subview.alpha < 0.01;
        if (skipHidden && isHidden) {
            continue;
        }
        
        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (subviewContainsPoint) {
            [subviewsAtPoint addObject:subview];
        }
        
        /* If this view doesn't clip to its bounds,
         we need to check its subviews even if it doesn't contain the selection point.
         They may be visible and contain the selection point.
         */
        if (subviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsAtPoint addObjectsFromArray:[self recursiveSubviewsAtPoint:pointInSubview inView:subview skipHiddenViews:skipHidden]];
        }
    }
    return subviewsAtPoint;
}
/**
 * 清空单签框选
 */
- (void)clearAllOutlineViews {
    for (UIView *view in self.currentTapOutlineViews) {
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
}

- (void)targetDetailAction {
    if (self.indexBlock) {
        self.indexBlock(self.currentSelectView, 0);
    }
}

- (void)targetViewsAction {
    if (self.indexBlock) {
        self.indexBlock(self.currentSelectView, 1);
    }
}

@end
