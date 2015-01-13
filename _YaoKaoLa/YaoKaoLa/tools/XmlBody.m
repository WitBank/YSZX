//
//  XmlBody.m
//  test
//
//  Created by pro on 14/11/27.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "XmlBody.h"
@interface XmlBody()
{
    NSMutableString *_xml;
}
@end
@implementation XmlBody
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"xmlPostBody" ofType:@"xml"];
        _xml = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return self;
}
- (void)setPageXml:(NSString*)pageXml whereXml:(NSString *)whereXml pageType:(NSString *)pageType functionType:(NSString *)functionType dataType:(NSString *)dataType{
    if (!pageXml) {
        pageXml = @"";
    }
    if (!whereXml) {
        whereXml = @"";
    }
    if (!pageType) {
        pageType = @"";
    }
    if (!functionType) {
        functionType = @"";
    }
    if (!dataType) {
        dataType = @"";
    }
    //xml转义字符转换
    pageXml = [XmlBody xmlConVert:pageXml];
    whereXml = [XmlBody xmlConVert:whereXml];
    pageType = [XmlBody xmlConVert:pageType];
    functionType = [XmlBody xmlConVert:functionType];
    dataType = [XmlBody xmlConVert:dataType];
    
    
    [_xml replaceOccurrencesOfString:@"_pageXml" withString:pageXml options:0 range:NSMakeRange(0, _xml.length)];
    [_xml replaceOccurrencesOfString:@"_whereXml" withString:whereXml options:0 range:NSMakeRange(0, _xml.length)];
    [_xml replaceOccurrencesOfString:@"_pageType" withString:pageType options:0 range:NSMakeRange(0, _xml.length)];
    [_xml replaceOccurrencesOfString:@"_functionType" withString:functionType options:0 range:NSMakeRange(0, _xml.length)];
    [_xml replaceOccurrencesOfString:@"_dataType" withString:dataType options:0 range:NSMakeRange(0, _xml.length)];
}
-(NSString *)xmlString{
    return _xml;
}
- (NSData *)xmlData{
    return [_xml dataUsingEncoding:NSUTF8StringEncoding];
}
//< > & ' " 转义字符的转化 &lt; &gt; &amp; &apos; &quot;
+ (NSString *)xmlConVert:(NSString *)str{
    NSMutableString *string = [NSMutableString stringWithString:str];
    [string replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, string.length)];
    return string;
}
//反转
+ (NSString *)convertXMl:(NSString *)str{
    NSMutableString *string = [NSMutableString stringWithString:str];
    [string replaceOccurrencesOfString:@"&amp;lt;br&amp;gt;" withString:@"\n" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"&amp;amp;amp;lt;" withString:@"" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"&amp;amp;amp;gt;" withString:@"" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"&#xD;" withString:@"" options:0 range:NSMakeRange(0, string.length)];
    return string;
}

@end
