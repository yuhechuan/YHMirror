//
//  YHMirrorDebugDetailController.m
//  YHMirrorUI
//
//  Created by yuhechuan on 2020/8/26.
//  Copyright © 2020 yuhechuan. All rights reserved.
//

#import "YHMirrorDebugDetailController.h"
#import "YHMirrorDebugModel.h"
#import <objc/runtime.h>

#define YH_SF_FONT  @".SFUIText"

@interface YHMirrorDebugDetailController ()

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) NSArray <YHMirrorDebugSection *>* briefModels;
@property (nonatomic, strong) NSArray <YHMirrorDebugSection *>* uiModels;

@end

@implementation YHMirrorDebugDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUp];
}

- (void)setUp {
    if ([self.selectObject isKindOfClass:UIView.class]) {
        [self setNavigationItemViewType];
    } else {
        [self setNavigationItemOtherType];
    }
}

- (void)setNavigationItemViewType {
    [self customNavigationItemTitle:nil];
    self.navigationItem.titleView = self.segmentView;
    [self.debugTableView reloadWithModels:self.briefModels];
}

- (void)setNavigationItemOtherType {
    [self customNavigationItemTitle:NSStringFromClass([self.selectObject class])];
    [self.debugTableView reloadWithModels:self.uiModels];
}

/**
 * 创建头部button
 */
- (UIButton *)segmentButtonWithTitle:(NSString *)title
                               frame:(CGRect)frame
                            tagValue:(int)tagValue {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.tag = tagValue;
    return btn;
}


- (void)segmentAction:(UIButton *)selectBtn {
    for (UIButton *btn in self.segmentView.subviews) {
        if ([btn isKindOfClass:UIButton.class]) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }
    }
    [selectBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [selectBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:139/255.0 blue:6/255.0 alpha:1] forState:UIControlStateNormal];
    if (selectBtn.tag == 0) {
        [self.debugTableView reloadWithModels:self.briefModels];
    } else {
        [self.debugTableView reloadWithModels:self.uiModels];
    }
}

- (UIView *)segmentView {
    if (!_segmentView) {
        CGFloat segHeight = 38;
        CGFloat segWidth = 120;
        _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, segWidth, segHeight)];
        _segmentView.backgroundColor = [UIColor clearColor];
        //[self.view addSubview:self.segmentView];
        CGFloat btnWidth = segWidth / 2.0;
        UIButton *left = [self segmentButtonWithTitle:@"Brief" frame:CGRectMake(0, 0, btnWidth, segHeight) tagValue:0];
        [_segmentView addSubview:left];
        UIButton *right = [self segmentButtonWithTitle:@"UI" frame:CGRectMake(btnWidth, 0, btnWidth, segHeight) tagValue:1];
        [_segmentView addSubview:right];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth+1, 13, 1.5, 12)];
        line1.backgroundColor = [UIColor whiteColor];
        [_segmentView addSubview:line1];
        [self segmentAction:left];
    }
    return _segmentView;
}

- (NSArray<YHMirrorDebugSection *> *)briefModels {
    if (!_briefModels) {
        NSMutableArray *models = [[NSMutableArray alloc] init];
        YHMirrorDebugSection *generalModel = [self generalModelForSelectView];
        if (generalModel) {
            [models addObject:generalModel];
        }
        YHMirrorDebugSection *ivarModel = [self ivarListModelForSelectView];
        if (ivarModel) {
            [models addObject:ivarModel];
        }
        _briefModels = models.copy;
    }
    return _briefModels;
}

- (YHMirrorDebugSection *)generalModelForSelectView {
    if (![self.selectObject isKindOfClass:UIView.class]) return nil;
    
    YHMirrorDebugSection *model = [[YHMirrorDebugSection alloc] init];
    model.sectionTitle = @"General";
    UIView *selectView = (UIView *)self.selectObject;
    NSMutableString *viewPath = [[NSMutableString alloc] init];
    UIViewController *vc = nil;
    UITableView *firstTable = nil;
    UITableViewCell *firstCell = nil;
    UIView *current = selectView;
    
    NSMutableArray *overviewItems = [[NSMutableArray alloc] init];
    //view path
    while (current) {
        if (!firstTable && [current isKindOfClass:UITableView.class]) {
            firstTable = (UITableView *)current;
            
        }else if (!firstCell && [current isKindOfClass:UITableViewCell.class]) {
            firstCell = (UITableViewCell *)current;
        }
        [viewPath insertString:[NSString stringWithFormat:@"/%@",NSStringFromClass(current.class)] atIndex:0];
        if ([current.nextResponder isKindOfClass:UIViewController.class]) {
            [viewPath insertString:[NSString stringWithFormat:@"/%@",NSStringFromClass(current.nextResponder.class)] atIndex:0];
            vc = (UIViewController *)current.nextResponder;
            break;
        }
        current = current.superview;
    }
    [overviewItems addObject:yh_createItem(@"View Path", viewPath.copy)];
    
    //frame
    NSString *frame = NSStringFromCGRect(selectView.frame);
    [overviewItems addObject:yh_createItem(@"Frame", frame)];

    //index
    if (firstCell) {
        NSIndexPath *index = [firstTable indexPathForCell:firstCell];
        if (index) {
            NSString *cellIndex = [NSString stringWithFormat:@"%ld:%ld", index.section, index.row];
            [overviewItems addObject:yh_createItem(@"Cell Index", cellIndex)];
        }
    }
    
    //pageTitle
    NSString *title = nil;
    if (vc.navigationItem.titleView) {
        for (UIView *view in vc.navigationItem.titleView.subviews) {
            if ([view isKindOfClass:UILabel.class]) {
                title = [(UILabel *)view text];
            }else if ([view isKindOfClass:UIButton.class]){
                title = [(UIButton *)view titleForState:UIControlStateNormal];
            }
        }
    }else if (vc.navigationItem.title){
        title = vc.navigationItem.title;
    }
    if (title) {
        [overviewItems addObject:yh_createItem(@"Page Title", title)];
    }
    
    //viewTitle
    NSString *viewTitle = nil;
    if ([selectView isKindOfClass:UIButton.class]) {
        viewTitle = [(UIButton *)selectView titleForState:UIControlStateNormal];
        
    }else if ([selectView isKindOfClass:UILabel.class]) {
        viewTitle = [(UILabel *)selectView text];
        
    }else if ([selectView isKindOfClass:UIAlertAction.class]){
        viewTitle = [(UIAlertAction *)selectView title];
    }
    if (viewTitle) {
        [overviewItems addObject:yh_createItem(@"View Title", viewTitle)];
    }
    
    //selector
    NSString *selectorName = nil;
    if ([selectView isKindOfClass:UIControl.class]) {
        UIControl *tempControl = (UIControl *)selectView;
        NSSet *targets = [tempControl allTargets];
        for (id target in targets) {
            NSArray *selArray = [tempControl actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            if ([selArray firstObject]) selectorName = [selArray firstObject];
            break;
        }
    }else if (selectView.gestureRecognizers.count > 0){
        NSMutableString *selectList = [[NSMutableString alloc] init];
        for (UIGestureRecognizer *gesture in selectView.gestureRecognizers) {
            Ivar targetsIvar = class_getInstanceVariable([UIGestureRecognizer class], "_targets");
            id targetActionPairs = object_getIvar(gesture, targetsIvar);
            
            Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
            Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
            
            for (id targetActionPair in targetActionPairs)
            {
                SEL action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
                [selectList appendFormat:@"\n%@",NSStringFromSelector(action)];
            }
        }
        selectorName = selectList;
    }
    if (selectorName) {
        [overviewItems addObject:yh_createItem(@"Selector", selectorName)];
    }
    
    //tag
    if (selectView.tag) {
        NSString *tagString = [NSString stringWithFormat:@"%ld",selectView.tag];
        [overviewItems addObject:yh_createItem(@"Tag", tagString)];
    }
    
    model.sectionItems = overviewItems;
    return model;
}

- (YHMirrorDebugSection *)ivarListModelForSelectView {
    YHMirrorDebugSection *model = [[YHMirrorDebugSection alloc] init];
    model.sectionTitle = @"Ivar List";
    
    NSMutableArray *overviewItems = [[NSMutableArray alloc] init];
    unsigned int ivarCount = 0;
    Ivar * ivars = class_copyIvarList([self.selectObject class], &ivarCount);
    for (unsigned int i = 0; i < ivarCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        if (!name) continue;
        NSString *field = [NSString stringWithUTF8String:name];
        
        const char * type = ivar_getTypeEncoding(ivar);
        NSString *typeEncode = @"";
        if (type) {
            typeEncode = [NSString stringWithUTF8String:type];
        }
        if ([typeEncode hasPrefix:@"^"] || [typeEncode hasPrefix:@"{?"]) {
            //filter pointer and unknown type
            continue;
        }
        
        if ([typeEncode hasPrefix:@"@"]) {
            typeEncode = [typeEncode stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            typeEncode = [typeEncode stringByReplacingOccurrencesOfString:@"@" withString:@""];
            typeEncode = [typeEncode stringByAppendingString:@" *"];
        }else if ([typeEncode hasPrefix:@"B"]){
            typeEncode = @"BOOL";

        }else if ([typeEncode hasPrefix:@"i"]){
            typeEncode = @"int";

        }else if ([typeEncode hasPrefix:@"d"]){
            typeEncode = @"double";

        }else if ([typeEncode hasPrefix:@"q"]){
            typeEncode = @"long long";

        }else if ([typeEncode hasPrefix:@"f"]){
            typeEncode = @"float";

        }else if ([typeEncode hasPrefix:@"l"]){
            typeEncode = @"long";

        }else if ([typeEncode hasPrefix:@"Q"]){
            typeEncode = @"unsigned long long";
            
        }else if ([typeEncode hasPrefix:@"{"]) {//structure
            NSString *first = [[typeEncode componentsSeparatedByString:@"="] firstObject];
            if (first) {
                first = [first stringByReplacingOccurrencesOfString:@"{" withString:@""];
                typeEncode = first;
            }
        }

        id val = nil;
        @try {
            val = [self.selectObject valueForKey:field];

        } @catch (NSException *exception) {
            
        } @finally {
            if (!val) {
                val = @"nil";
            }
            NSString *value = [NSString stringWithFormat:@"(%@)%@",typeEncode,val];
            [overviewItems addObject:yh_createItem(field, value)];
        }
    }
    free(ivars);
    
    model.sectionItems = overviewItems;
    return model;
}

- (NSArray<YHMirrorDebugSection *> *)uiModels {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    YHMirrorDebugSection *textm = [self basicUIModelForSelectView];
    if (textm) [items addObject:textm];
    YHMirrorDebugSection *colorm = [self corlorUIModelForSelectView];
    if (colorm) [items addObject:colorm];
    YHMirrorDebugSection *fontm = [self fontUIModelForSelectView];
    if (fontm) [items addObject:fontm];
    
    return items.copy;
}


- (YHMirrorDebugSection *)basicUIModelForSelectView {
    if (![self.selectObject isKindOfClass:UIView.class]) {
        return nil;
    }
    UIView *selectView = (UIView *)self.selectObject;
    YHMirrorDebugSection *model = [[YHMirrorDebugSection alloc] init];
    model.sectionTitle = [NSString stringWithFormat:@"%@ Basic", NSStringFromClass(selectView.class)];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    //frame
    NSString *frame = NSStringFromCGRect(selectView.frame);
    [items addObject:yh_createOptionsItem(@"Frame", frame, nil, nil, ^{
        //[self showUpdateViewWithType:KZMUITypeFrame addtion:nil];
    })];
    //text
    NSString *text = nil;
    if ([selectView isKindOfClass:UILabel.class]) {
        text = [(UILabel *)selectView text];
        
    }else if ([selectView isKindOfClass:UIButton.class]) {
        text = [(UIButton *)selectView titleForState:UIControlStateNormal];
        
    }else if ([selectView isKindOfClass:NSClassFromString(@"YPSeniorLabel")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([selectView respondsToSelector:@selector(attributedString)]) {
            NSAttributedString *attr = [selectView performSelector:@selector(attributedString)];
            if (attr && [attr isKindOfClass:NSAttributedString.class]) {
                text = attr.string;
            }
        }
#pragma clang diagnostic pop
    }
    if (text) {
        [items addObject:yh_createOptionsItem(@"Text", text, nil, nil, ^{
            //[self showUpdateViewWithType:KZMUITypeText addtion:text];
        })];
    }
    model.sectionItems = items;
    return model;
}

- (YHMirrorDebugSection *)corlorUIModelForSelectView {
    if (![self.selectObject isKindOfClass:UIView.class]) {
        return nil;
    }
    UIView *selectView = (UIView *)self.selectObject;
    YHMirrorDebugSection *model = [[YHMirrorDebugSection alloc] init];
    model.sectionTitle = @"Colors";
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSString * (^colorFormatString)(UIColor *color) = ^NSString *(UIColor *color) {
        if (!color) return nil;
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        BOOL result = [color getRed:&red green:&green blue:&blue alpha:&alpha];
        if (!result) return nil;
        NSString *colorStr = [NSString stringWithFormat:@"red:%.0f  green:%.0f  blue:%.0f  alpha:%.0f", red*255.0,green*255.0,blue*255.0,alpha];
        return colorStr;
    };
    
    //background color
    UIColor *backColor = selectView.backgroundColor;
    NSString *backColorStr = colorFormatString(backColor);
    if (backColor) {
        [items addObject:yh_createOptionsItem(@"Background Color", backColorStr, backColor, nil, ^{
            //[self showUpdateViewWithType:KZMUITypeBackColor addtion:backColor];
        })];

    }
    //text color
    UIColor *textColor = nil;
    if ([selectView isKindOfClass:UILabel.class]) {
        textColor = [(UILabel *)selectView textColor];
        
    }else if ([selectView isKindOfClass:UIButton.class]) {
        textColor = [(UIButton *)selectView titleColorForState:UIControlStateNormal];
        
    }else if ([selectView isKindOfClass:NSClassFromString(@"YPSeniorLabel")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([selectView respondsToSelector:@selector(textColor)]) {
            textColor = [selectView performSelector:@selector(textColor)];
        }
#pragma clang diagnostic pop
    }
    NSString *textColorStr = colorFormatString(textColor);
    if (textColorStr) {
        [items addObject:yh_createOptionsItem(@"Text Color", textColorStr, textColor, nil, ^{
            //[self showUpdateViewWithType:KZMUITypeTextColor addtion:textColor];
        })];
    }
    model.sectionItems = items;
    return model;
}

- (YHMirrorDebugSection *)fontUIModelForSelectView {
    if (![self.selectObject isKindOfClass:UIView.class]) {
        return nil;
    }
    UIView *selectView = (UIView *)self.selectObject;
    YHMirrorDebugSection *model = [[YHMirrorDebugSection alloc] init];
    model.sectionTitle = @"Font";
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIFont *textFont = nil;
    if ([selectView isKindOfClass:UILabel.class]) {
        textFont = [(UILabel *)selectView font];
        
    }else if ([selectView isKindOfClass:UIButton.class]) {
        textFont = [(UIButton *)selectView titleLabel].font;
        
    }else if ([selectView isKindOfClass:NSClassFromString(@"YPSeniorLabel")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([selectView respondsToSelector:@selector(font)]) {
            textFont = [selectView performSelector:@selector(font)];
        }
#pragma clang diagnostic pop
    }
    if (textFont) {
        NSString *curFontFamily = textFont.familyName;
        if ([curFontFamily containsString:@".SF"]) {
            curFontFamily = YH_SF_FONT;
        }
        [items addObject:yh_createOptionsItem(@"Font", textFont.fontName, nil, textFont, ^{
            //[self showUpdateViewWithType:KZMUITypeFontDesc addtion:nil];
        })];
        NSString *fontSize = [NSString stringWithFormat:@"%.1f",textFont.pointSize];
        [items addObject:yh_createOptionsItem(@"Font Size", fontSize, nil, textFont, ^{
            //[self showUpdateViewWithType:KZMUITypeFontSize addtion:fontSize];
        })];
    }
    model.sectionItems = items;
    return model;
}

@end
