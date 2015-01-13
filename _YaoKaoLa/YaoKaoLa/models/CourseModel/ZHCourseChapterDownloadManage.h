//
//  ZHCourseChapterDownloadManage.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/29.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseManagedObject.h"
#import "ZHCourseChapterModel.h"

@interface ZHCourseChapterDownloadManage : ZHBaseManagedObject

@property (nonatomic, copy) NSString *courseId;     //课程id
@property (nonatomic, copy) NSString *fileId;       //章节id
@property (nonatomic, copy) NSString *fileName;     //课程名称
@property (nonatomic, copy) NSString *fileTime;     //课程总时间
@property (nonatomic, copy) NSString *fileUrl;      //视频地址
@property (nonatomic, copy) NSString *fileNumber;   //视频的总量
@property (nonatomic, copy) NSString *acntNumber;   //账号
@property (nonatomic, copy) NSString *isDownload;   //是否下载完成
@property (nonatomic, copy) NSString *examinationId;//试卷ID

@end
