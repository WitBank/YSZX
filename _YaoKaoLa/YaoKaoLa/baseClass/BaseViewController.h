//
//  BaseViewController.h
//  test
//
//  Created by pro on 14/11/27.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AControll.h"
#import "SVProgressHUD.h"
//rgb颜色转化   UIColorFromRGB(0x34465C);
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//view 尺寸
#define WinSize [UIScreen mainScreen].bounds.size
//颜色
#define RGBColor(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
@interface BaseViewController : UIViewController
{
    CGFloat _allController_y;
}

//返回按钮
- (void)setBackWithDisMissOrPop:(int)back;

//显示请求的信息
- (void)showMsg:(NSString *)msg;

@end
