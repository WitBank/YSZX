//
//  CourseChapterDownloadCell.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "CourseChapterDownloadCell.h"
#import "DownLoadOperation.h"
#import "VideoURLStringEncryption.h"
#import "ZHCoreDataManage.h"


@implementation CourseChapterDownloadCell
{
    BOOL _leftButtonSelected;
//    BOOL _rightButtonSelected;
    DownLoadOperation *_operation;
    ZHCourseChapterModel *_model;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showLabelDataWithModel:(ZHCourseChapterModel *)model andIsDownLoad:(BOOL)isDownLoad
{
//    _siDownloadManager = [SIDownloadManager sharedSIDownloadManager];
    _model = model;
    _number = 0;
    [_contentLabel setText:_model.fileName];
    if ([model.isDownload isEqualToString:@"1"]) {
        [_timeLabel setText:@"100%"];
    }else{
        [_timeLabel setText:@"--"];
    }
    if (model.fileNumber != nil && ![model.fileNumber isEqualToString:@""]) {
        [_totalLabel setText:[NSString stringWithFormat:@"%.1lfM",((unsigned)[model.fileNumber longLongValue])/(1024.0*1024)]];
    }else{
        [_totalLabel setText:@"0.0M"];
    }
    
    if (isDownLoad == YES) {
        _rightButtonType = RightButtonTypeWithDownload;
        [_downloadButton setImage:[UIImage imageNamed:@"ZH_CourseDetail_Download_lan@3x"] forState:UIControlStateNormal];
//        [self startDownload];
    }else{
        _rightButtonType = RightButtonTypeWithNormal;
        [_downloadButton setImage:[UIImage imageNamed:@"ZH_CourseDetail_Download_lan_normal@3x"] forState:UIControlStateNormal];
    }
    NSArray *arrya = [ZHCoreDataManage getAllDownloadVideoModelArray];
    for (int i = 0; i < [arrya count]; i++) {
        ZHCourseChapterModel *saModel = [arrya objectAtIndex:i];
        if ([saModel.fileId isEqualToString:_model.fileId]) {
            if ([saModel.isDownload isEqualToString:@"1"]) {
                _rightButtonType = RightButtonTypeWithPlay;
                [_downloadButton setImage:[UIImage imageNamed:@"course_select@3x"] forState:UIControlStateNormal];
//                [self pauseDownload];
                break;
            }
        }
    }
}

- (IBAction)chapterDownloadClicked:(UIButton *)sender {
    if (sender.tag == 1001) {
        if (_leftButtonSelected == YES) {
            [_selectButton setImage:[UIImage imageNamed:@"currentimg_normal@3x"] forState:UIControlStateNormal];
            _leftButtonSelected = NO;
        }else{
            [_selectButton setImage:[UIImage imageNamed:@"currentimg.png"] forState:UIControlStateNormal];
            _leftButtonSelected = YES;
        }
        if (_selectLeft) {
            _selectLeft(_leftButtonSelected);
        }
    }else if (sender.tag == 1002){
        if (_rightButtonType == RightButtonTypeWithDownload) {
            [_downloadButton setImage:[UIImage imageNamed:@"ZH_CourseDetail_Download_lan_normal@3x"] forState:UIControlStateNormal];
            _rightButtonType = RightButtonTypeWithNormal;
//            if (_delegate && [_delegate respondsToSelector:@selector(canceledDownload:)]) {
//                [_delegate canceledDownload:self];
//            }
        }else if(_rightButtonType == RightButtonTypeWithNormal){
            [_downloadButton setImage:[UIImage imageNamed:@"ZH_CourseDetail_Download_lan@3x"] forState:UIControlStateNormal];
            _rightButtonType = RightButtonTypeWithDownload;
//            if (_delegate && [_delegate respondsToSelector:@selector(resumeDownload:)]) {
//                [_delegate resumeDownload:self];
//            }
        }
        if (_selectDownload) {
            _selectDownload(_rightButtonType);
        }
    }
}

- (void)setDownloadButtonType:(RightButtonType)type
{
    switch (type) {
        case RightButtonTypeWithNormal:
            [_downloadButton setImage:[UIImage imageNamed:@"ZH_CourseDetail_Download_lan_normal@3x"] forState:UIControlStateNormal];
            _rightButtonType = RightButtonTypeWithNormal;
            break;
        case RightButtonTypeWithDownload:
            [_downloadButton setImage:[UIImage imageNamed:@"ZH_CourseDetail_Download_lan@3x"] forState:UIControlStateNormal];
            _rightButtonType = RightButtonTypeWithDownload;
            break;
        case RightButtonTypeWithPlay:
            [_downloadButton setImage:[UIImage imageNamed:@"course_select@3x"] forState:UIControlStateNormal];
            _rightButtonType = RightButtonTypeWithPlay;
            break;
        default:
            break;
    }
}

//- (void)startDownload
//{
//    NSString *sd= [VideoURLStringEncryption getNewURLStringWithPath:_model.fileUrl];
//    NSString *fileName = [NSString stringWithFormat:@"Documents/%@.mp4",_model.fileId];
//    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
//    _operation = [[DownLoadOperation alloc] init];
//    [_operation downloadWithUrl:[VideoURLStringEncryption getNewURLStringWithPath:_model.fileUrl]
//                     cachePath:^NSString *{
//                         return path;
//                     } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//                         _number++;
//                         if (_number >= 10) {
//                             _number = 0;
//                             if (_model.fileNumber == nil || [_model.fileNumber isEqualToString:@""]) {
//                                 _model.fileNumber = [NSString stringWithFormat:@"%.2fM",totalBytesExpectedToRead/(1024.0*1024)];
//                                 [_totalLabel setText:[NSString stringWithFormat:@"(%@)",_model.fileNumber]];
//                             }
//                             float progress = totalBytesRead / (float)totalBytesExpectedToRead;
//                             [_timeLabel setText:[NSString stringWithFormat:@"%.0f%%",progress*100]];
//                             [ZHCoreDataManage saveDownloadProgressWithModel:_model];
//                         }
//                         
//                         
//                     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                         
//                         [ZHCoreDataManage saveVideoDownloadModel:_model];
//                         
//                         
//                         
//                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                         NSLog(@"error = %@",error);
//                     }];
//}
//
//- (void)pauseDownload
//{
//    [_operation.requestOperation pause];
//}
//
//- (void)deleteDownload
//{
//    [_operation.requestOperation resume];
//}

//- (void)startDownload
//{
//    NSString *fileName = [NSString stringWithFormat:@"Documents/%@.mp4",_model.fileId];
//    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
//    
//    [_siDownloadManager addDownloadFileTaskInQueue:[VideoURLStringEncryption getNewURLStringWithPath:_model.fileUrl]
//                                        toFilePath:path
//                                  breakpointResume:YES
//                                       rewriteFile:NO];
//}
//
//- (void)pauseDownload
//{
//    [_siDownloadManager cancelDownloadFileTaskInQueue:[VideoURLStringEncryption getNewURLStringWithPath:_model.fileUrl]];
//}
//
//- (void)deleteDownload
//{
//    NSString *fileName = [NSString stringWithFormat:@"Documents/%@.mp4",_model.fileId];
//    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        [fileManager removeItemAtPath:path error:nil];
//    }
//}

//#pragma mark - SIDownloadManagerDelegate
//- (void)downloadManager:(SIDownloadManager *)siDownloadManager
//          withOperation:(SIBreakpointsDownload *)paramOperation
//         changeProgress:(double)paramProgress
//{
////    if ([urlOne isEqualToString:paramOperation.url]) {
////        _progressViewOne.progress = paramProgress;
////        [_labelOne setText:[NSString stringWithFormat:@"%.1f%%", paramProgress * 100]];
////    }else if([urlTwo isEqualToString:paramOperation.url]){
////        _progressViewTwo.progress = paramProgress;
////        [_labelTwo setText:[NSString stringWithFormat:@"%.1f%%", paramProgress * 100]];
////    }
//    NSLog(@"%lf",paramOperation);
//}
//
//- (void)downloadManagerDidComplete:(SIDownloadManager *)siDownloadManager
//                     withOperation:(SIBreakpointsDownload *)paramOperation
//{
////    if ([paramOperation.url isEqualToString:urlOne]) {
////        NSLog(@"done one");
////    }else if([paramOperation.url isEqualToString:urlTwo]){
////        NSLog(@"done two");
////    }
//    
//}
//
//- (void)downloadManagerError:(SIDownloadManager *)siDownloadManager
//                     withURL:(NSString *)paramURL
//                   withError:(NSError *)paramError
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"请检查你的网络连接状态！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"确认",nil];
//    [alertView show];
//    
//}
//
//- (void)downloadManagerDownloadDone:(SIDownloadManager *)siDownloadmanager
//                            withURL:(NSString *)paramURL
//{
//    NSLog(@"done");
//}
//
//- (void)downloadManagerPauseTask:(SIDownloadManager *)siDownloadManager
//                         withURL:(NSString *)paramURL
//{
//    
//}
//
//- (void)downloadManagerDownloadExist:(SIDownloadManager *)siDwonloadManager
//                             withURL:(NSString *)paramURL
//{
//    
//}
//
//#pragma mark - others
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}



@end
