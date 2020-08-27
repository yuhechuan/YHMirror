//
//  YHMacro.h
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/26.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#ifndef YHMacro_h
#define YHMacro_h

#define YH_IS_IPHONEX ([[UIScreen mainScreen] bounds].size.height >= 812.0 ? YES : NO)
#define YH_NAVHEIGHT (YH_IS_IPHONEX ? 88 : 64)
#define YH_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define YH_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define YHIPhoneXTop ([[UIScreen mainScreen] bounds].size.height>=812?24:0)
#define YHIphoneXBottom ([[UIScreen mainScreen] bounds].size.height>=812?34:0)
#define YH_COLOR(_red,_green,_blue) [UIColor colorWithRed:_red/255. green:_green/255. blue:_blue/255. alpha:1]
#define YH_THEME_COLOR (YH_COLOR(83, 139, 6))


#endif /* YHMacro_h */
