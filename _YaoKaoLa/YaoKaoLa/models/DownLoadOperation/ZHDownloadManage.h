//
//  ZHDownloadManage.h
//  YaoKaoLa
//
//  Created by HuXin on 15/1/8.
//  Copyright (c) 2015年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHCourseChapterModel.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface ZHDownloadManage : NSObject<NSURLSessionDownloadDelegate,NSURLConnectionDataDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>

/* NSURLSessions */
//@property (strong, nonatomic)           NSURLSession *currentSession;    // 当前
//@property (strong, nonatomic, readonly) NSURLSession *backgroundSession; // 后台
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *partialData;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) void (^completeDownload)(BOOL);
@property (nonatomic, strong) void (^processChange)(double,int64_t);
@property(nonatomic, retain) ASINetworkQueue *asiQueue;
@property(nonatomic, retain) ASIHTTPRequest *asiHttpRequest;

- (instancetype)initWithModel:(ZHCourseChapterModel *)model;

//开始
- (void)_StartDownload;
//取消
-(void)_PauseDownload;
//恢复
-(void)_ResumeDownload;

@end
