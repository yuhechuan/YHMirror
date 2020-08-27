//
//  YHMirrorTreeView.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YHTapMenuIndexBlock)(UIView *selectView, int index);

@interface YHMirrorTreeView : UIView

@property (nonatomic, strong) YHTapMenuIndexBlock indexBlock;

- (void)updateCurrentKeyWindow:(UIWindow *)userKeyWindow;

@end

NS_ASSUME_NONNULL_END
