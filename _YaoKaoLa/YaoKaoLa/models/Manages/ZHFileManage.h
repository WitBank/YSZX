//
//  ZHFileManage.h
//  YaoKaoLa
//
//  Created by HuXin on 15/1/9.
//  Copyright (c) 2015年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHFileManage : NSObject

+(void)removeVideoWithUserName:(NSString *)userName andFileId:(NSString *)fileId andIsDownload:(BOOL)isDownload;

@end
