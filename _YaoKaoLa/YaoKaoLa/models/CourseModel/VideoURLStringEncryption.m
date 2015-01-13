//
//  VideoURLStringEncryption.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "VideoURLStringEncryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation VideoURLStringEncryption

+(NSString *)getNewURLStringWithPath:(NSString *)urlPath
{
    NSMutableString *newURLString = [NSMutableString stringWithString:urlPath];
    NSString *path_String = [urlPath substringFromIndex:23];
    NSDate *date = [[NSDate alloc] init];
    NSTimeInterval timeNum = [date timeIntervalSince1970];
    NSString *t_string =[NSString stringWithFormat:@"%d",(int)timeNum];
    NSString *time_String = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[t_string intValue]]];
    NSString *md5String = [VideoURLStringEncryption md5:[NSString stringWithFormat:@"cmstpxtime%@%@",path_String,time_String]];
    [newURLString appendFormat:@"?KEY1=%@&KEY2=%@",md5String,time_String];
    return newURLString;
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}


@end
