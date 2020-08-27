//
//  YHMirrorWindow.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/20.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHMirrorWindow : UIWindow

@property (nonatomic, copy) BOOL(^pointInsideWindowMainControllerBlock)(CGPoint point);

@end

NS_ASSUME_NONNULL_END
