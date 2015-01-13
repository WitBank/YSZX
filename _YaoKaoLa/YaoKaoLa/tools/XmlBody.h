//
//  XmlBody.h
//  test
//
//  Created by pro on 14/11/27.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlBody : NSObject
//传参赋值
- (void)setPageXml:(NSString*)pageXml whereXml:(NSString *)whereXml pageType:(NSString *)pageType functionType:(NSString *)functionType dataType:(NSString *)dataType;

//获取xml内容
- (NSData *)xmlData;
-(NSString *)xmlString;
//< > & ' " 转义字符的转化 &lt; &gt; &amp; &apos; &quot;
+ (NSString *)xmlConVert:(NSString *)str;
//反转
+ (NSString *)convertXMl:(NSString *)str;
@end
