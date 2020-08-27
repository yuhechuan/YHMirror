//
//  YHMirrorNavigationController.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/25.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorNavigationController.h"

@interface YHMirrorNavigationController ()

@end

@implementation YHMirrorNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    static UIImage *shadowImage = nil;
    if (!shadowImage) {
        //nav line color
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
        UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        shadowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [self.navigationBar setShadowImage:shadowImage];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:25/255. green:25/255. blue:25/255. alpha:1]];
    // Do any additional setup after loading the view.
}


@end
