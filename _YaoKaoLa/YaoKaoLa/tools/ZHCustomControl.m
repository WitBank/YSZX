//
//  ZHCustomControl.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHCustomControl.h"
#import "Reachability.h"

@implementation ZHCustomControl

/**
 *  工厂方法创建Label
 *
 *  @param title      Label的title
 *  @param font       title的字体大小
 *  @param titleColor title的字体颜色
 *  @param rect       title的frame
 *
 *  @return UILabel
 */
+(UILabel *)_customLabelWithTitle:(NSString *)title
                         andFont:(CGFloat)font
                   andTitleColor:(UIColor *)titleColor
                        andFrame:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextColor:titleColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:font]];
    [label setFrame:rect];
    [label setAdjustsFontSizeToFitWidth:YES];
    return label;
}

+(UIButton *)_customUIButtonWithTitle:(NSString *)title
                              andFont:(CGFloat)font
                        andTitleColor:(UIColor *)titleColor
                            andTarget:(id)target
                               andSEL:(SEL)action
                      andControlEvent:(UIControlEvents)event
                           andBGImage:(UIImage *)bgImage
                             andFrame:(CGRect)rect
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    [btn setFrame:rect];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:event];
    return btn;
}

+(BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    HJSTK_Reachability *reach = [HJSTK_Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case HJSTK_NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case HJSTK_ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case HJSTK_ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

@end
