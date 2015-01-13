//
//  ZHFileManage.m
//  YaoKaoLa
//
//  Created by HuXin on 15/1/9.
//  Copyright (c) 2015年 Huxin. All rights reserved.
//

#import "ZHFileManage.h"

@implementation ZHFileManage

+(void)removeVideoWithUserName:(NSString *)userName andFileId:(NSString *)fileId andIsDownload:(BOOL)isDownload
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 文件存放目录
        NSString* path = nil;
        if (isDownload) {
            NSString *fileName = [NSString stringWithFormat:@"Documents/%@/%@.mp4",userName,fileId];
            path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        }else{
            NSString *temp = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            path = [temp stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileId]];
        }
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:path];
        if (bRet) {
            //
            NSError *err;
            [fileMgr removeItemAtPath:path error:&err];
        }
    });
}

@end
