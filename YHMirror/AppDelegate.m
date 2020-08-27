//
//  AppDelegate.m
//  YHMirror
//
//  Created by yuhechuan on 2020/8/27.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "AppDelegate.h"
#import "YHMirror.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#ifdef DEBUG
    [[YHMirror shareMirror] openDefaultMirror];
#endif
    return YES;
}


@end
