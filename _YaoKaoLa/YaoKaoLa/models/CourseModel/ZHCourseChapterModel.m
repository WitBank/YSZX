//
//  ZHCourseChapterModel.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHCourseChapterModel.h"
#import "HTTPDownload.h"

@implementation ZHCourseChapterModel

-(void)canceled
{
    [self.nsHTTPDownload canceledDownload];
    
}

@end
