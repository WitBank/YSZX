//
//  ZHCustomControl.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZHCustomControl : NSObject

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
                         andFrame:(CGRect)rect;

/**
 *  工厂方法创建Button
 *
 *  @param title      Button的title
 *  @param font       title的字体大小
 *  @param titleColor title的字体颜色
 *  @param rect       title的frame
 *  @param target     使用button的对象
 *  @param action     button调用的方法
 *  @param bgImage    button的背景图片
 *
 *  @return Button
 */
+(UIButton *)_customUIButtonWithTitle:(NSString *)title
                              andFont:(CGFloat)font
                        andTitleColor:(UIColor *)titleColor
                            andTarget:(id)target
                               andSEL:(SEL)action
                      andControlEvent:(UIControlEvents)event
                           andBGImage:(UIImage *)bgImage
                             andFrame:(CGRect)rect;

+(BOOL)isConnectionAvailable;

@end
