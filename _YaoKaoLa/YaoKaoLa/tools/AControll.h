//
//  AControll.h
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "XmlBody.h"
#import "GDataXMLNode.h"
#import "AFHTTPRequestOperation.h"
@interface AControll : NSObject

//创建请求
+ (AFHTTPRequestOperation *)createHttpOperatWithXmlBody:(XmlBody *)xml;
//获得GetDataResult节点
+ (NSString *)getDataResultElementWithXml:(NSString *)xmlString;
+ (NSString *)getDataResultElementWithxxxml:(NSString *)xmlString;
+ (NSString *)getDataResultElementWithXml_2:(NSString *)xmlString;
//创建控件
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color backgroungImage:(NSString *)image tag:(int)tag;
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image tag:(int)tag;
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame plceCoder:(NSString *)coder;
//圆形按钮
+ (UIButton *)createRButtonFrame:(CGRect)frame title:(NSString *)title type:(int)type tag:(int)tag;
//数组排序
+ (void)sortArray:(NSMutableArray *)array;
//获取时间
+(NSString *)getTime;
+ (int)getMedicineType;
@end
