//
//  AControll.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "AControll.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation AControll
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color backgroungImage:(NSString *)image tag:(int)tag;{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = frame;
    if (title) {
        [bt setTitle:title forState:UIControlStateNormal];
    }

    if (color) {
        [bt setTitleColor:color forState:UIControlStateNormal];
    }
    if (image) {
        [bt setBackgroundImage:[UIImage imageNamed:image] forState: UIControlStateNormal];
    }
    bt.tag = tag;
    return bt;
}
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image tag:(int)tag{
    UIButton *ibt = [UIButton buttonWithType:UIButtonTypeCustom];
    ibt.tag = tag;
    [ibt setTitle:title forState:UIControlStateNormal];
    [ibt setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    ibt.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    ibt.frame = frame;
    float t = tag?(-14):(-12);
    [ibt setImageEdgeInsets:UIEdgeInsetsMake(-8, 15, 8, -15)];
    [ibt setTitleEdgeInsets:UIEdgeInsetsMake(15, t-3, -15, -t-4)];
    return ibt;
}
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.text = text;
    lb.textColor = color;
    lb.font = font;
    lb.textAlignment = NSTextAlignmentCenter;
    return lb;
}
//创建请求
+ (AFHTTPRequestOperation *)createHttpOperatWithXmlBody:(XmlBody *)xml{
    //58.83.193.180:1304
    //114.113.230.137
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://58.83.193.180:1304/Design_Time_Addresses/ServicesClientExam/Service1/?wsdl"]];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%lu",(unsigned long)xml.xmlString.length] forHTTPHeaderField:@"Content-Length"];
        
    [request addValue:[NSString stringWithFormat:@"%@%@",XMLHTTPHEAD,@"/IServiceInterface/GetData"] forHTTPHeaderField:@"SOAPAction"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:xml.xmlData];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    return op;
}
//获得GetDataResult节点
+ (NSString *)getDataResultElementWithXml:(NSString *)xmlString{
    xmlString = [XmlBody convertXMl:xmlString];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
    GDataXMLElement *result = [[doc nodesForXPath:@"//xmlns:GetDataResult" namespaces:@{@"xmlns":@"http://www.witbank.com.cn",@"s":@"http://schemas.xmlsoap.org/soap/envelope/"} error:nil] lastObject];
    return result.XMLString;
}

//获得GetDataResult节点
+ (NSString *)getDataResultElementWithxxxml:(NSString *)xmlString{
    NSMutableString *xString = [NSMutableString stringWithString:xmlString];
    xmlString = [xString stringByReplacingOccurrencesOfString:@"&lt;?xml   version=\"1.0\"   encoding=\"utf-8\"?&gt;  &#xD;" withString:@""];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
    GDataXMLElement *result = [[doc nodesForXPath:@"//xmlns:GetDataResult" namespaces:@{@"xmlns":@"http://www.witbank.com.cn",@"s":@"http://schemas.xmlsoap.org/soap/envelope/"} error:nil] lastObject];
    return result.XMLString;
}

//获得GetDataResult节点
+ (NSString *)getDataResultElementWithXml_2:(NSString *)xmlString{
    NSMutableString *xString = [NSMutableString stringWithString:xmlString];
    xmlString = [xString stringByReplacingOccurrencesOfString:@"&lt;?xml   version=\"1.0\"   encoding=\"utf-8\"?&gt;" withString:@""];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
    GDataXMLElement *result = [[doc nodesForXPath:@"//xmlns:GetDataResult" namespaces:@{@"xmlns":@"http://www.witbank.com.cn",@"s":@"http://schemas.xmlsoap.org/soap/envelope/"} error:nil] lastObject];
    return result.XMLString;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame plceCoder:(NSString *)coder{
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = coder;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.font = [UIFont boldSystemFontOfSize:16];
    return tf;
}
//圆形按钮
+ (UIButton *)createRButtonFrame:(CGRect)frame title:(NSString *)title type:(int)type tag:(int)tag;{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bt.frame = frame;
    [bt setTitle:title forState:UIControlStateNormal];
    bt.tag = tag;
    bt.layer.cornerRadius = frame.size.height*0.5;
    bt.titleEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
    bt.titleLabel.font = [UIFont systemFontOfSize:17];
    UIColor *color = UIColorFromRGB(0x2ea4fe);
    //未答
    if (type == 0) {
        bt.layer.borderColor = [[UIColor grayColor]CGColor];
        bt.layer.borderWidth = 0.5;
        [bt setTitleColor:color forState:UIControlStateNormal];
    }else if (type == 1){ //已答对
        bt.backgroundColor = color;
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (type == 2){ //错误
        bt.backgroundColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return bt;
}
+ (void)sortArray:(NSMutableArray *)array{
    if (array.count<=0) {
        return;
    }
    for (int i = 0; i < array.count-1 ; ++i) {
        for (int j = 0; j<array.count-1-i; ++j) {
            NSString *s = array[j+1];
            NSString *s1 = array[j];
            if ([s compare:s1] == NSOrderedAscending) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}
//获取时间
+(NSString *)getTime{
    //时间格式
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //设置时间戳格式 hh =12  HH =24
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate date];
    NSString *st = [format stringFromDate:date];
    return st;
}
//获取中药1西药0
+ (int)getMedicineType{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *st =[ud objectForKey:@"meDirection"];
    return [st intValue];
}

@end
