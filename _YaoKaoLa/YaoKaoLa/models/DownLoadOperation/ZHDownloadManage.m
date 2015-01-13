//
//  ZHDownloadManage.m
//  YaoKaoLa
//
//  Created by HuXin on 15/1/8.
//  Copyright (c) 2015年 Huxin. All rights reserved.
//

#import "ZHDownloadManage.h"
#import "VideoURLStringEncryption.h"
#import "ZHCoreDataManage.h"

@implementation ZHDownloadManage
{
    ZHCourseChapterModel *_model;
    unsigned long long _downLoadSize;
    NSURLConnection * _connection;
    unsigned long long _totalSize;
    NSFileHandle * _fileHandle;
}

- (instancetype)initWithModel:(ZHCourseChapterModel *)model
{
    self = [super init];
    _model = model;
    _asiQueue=[[ASINetworkQueue alloc]init];//开启队列
    [_asiQueue reset];//nil
    _asiQueue.showAccurateProgress=YES;//进度
    [_asiQueue go];
    return self;
}

//#pragma mark - DownloadData
//
//- (NSURLSession *)session
//{
//    //创建NSURLSession
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession  *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    return session;
//}
//
//- (NSURLRequest *)requestWithURLString:(NSString *)urlString
//{
//    //创建请求
//    NSURL *url = [NSURL URLWithString:[VideoURLStringEncryption getNewURLStringWithPath:urlString]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    return request;
//}
//
//-(void)_StartDownload
//{
//    //用NSURLSession和NSURLRequest创建网络任务
//    _task = [[self session] downloadTaskWithRequest:[self requestWithURLString:_model.fileUrl]];
//    [_task resume];
//}
//
//-(void)_PauseDownload
//{
//    if (_task) {
//        //取消下载任务，把已下载数据存起来
//        [_task cancelByProducingResumeData:^(NSData *resumeData) {
//            _partialData = resumeData;
//            _task = nil;
//        }];
//    }
//}
//
//-(void)_ResumeDownload
//{
//    if (!_task) {
//        //判断是否又已下载数据，有的话就断点续传，没有就完全重新下载
//        if (_partialData) {
//            _task = [[self session] downloadTaskWithResumeData:_partialData];
//        }else{
//            _task = [[self session] downloadTaskWithRequest:[self requestWithURLString:_model.fileUrl]];
//        }
//    }
//    [_task resume];
//}
//
////创建文件本地保存目录
//-(NSURL *)createDirectoryForDownloadItemFromURL:(NSURL *)location
//{
//    //    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    //    NSURL *documentsDirectory = urls[0];
//    //    return [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
//    NSArray *array = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]];
//    NSString *path = [NSString stringWithFormat:@"Documents/%@/%@.mp4",[[array objectAtIndex:0] objectForKey:@"username"],_model.fileId];
//    NSURL *URL = [NSURL fileURLWithPath:path];
//    return URL;
//}
////把文件拷贝到指定路径
//-(BOOL) copyTempFileAtURL:(NSURL *)location toDestination:(NSURL *)destination
//{
//    
//    NSError *error;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtURL:destination error:NULL];
//    [fileManager copyItemAtURL:location toURL:destination error:&error];
//    if (error == nil) {
//        return true;
//    }else{
//        NSLog(@"%@",error);
//        return false;
//    }
//}
//
//#pragma mark - NSURLSessionDownloadDelegate
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    //下载成功后，文件是保存在一个临时目录的，需要开发者自己考到放置该文件的目录
//    NSLog(@"Download success for URL: %@",location.description);
//    NSURL *destination = [self createDirectoryForDownloadItemFromURL:location];
//    BOOL success = [self copyTempFileAtURL:location toDestination:destination];
//    if(success){
//        //        文件保存成功后，使用GCD调用主线程把图片文件显示在UIImageView中
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_completeDownload) {
//                _completeDownload();
//            }
//            [ZHCoreDataManage saveVideoDownloadModel:_model];
//        });
//    }else{
//        NSLog(@"Meet error when copy file");
//    }
//    _task = nil;
//}
//
///* Sent periodically to notify the delegate of download progress. */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    //刷新进度条的delegate方法，同样的，获取数据，调用主线程刷新UI
////    double currentProgress = totalBytesWritten/(double)totalBytesExpectedToWrite;
////    dispatch_async(dispatch_get_main_queue(), ^{
////        if (_processChange) {
////            _processChange(currentProgress,totalBytesExpectedToWrite);
////        }
//        
////    });
//}
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//}


#pragma mark - NSURLConnectionDataDelegate
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]];
    NSString *fileName = [NSString stringWithFormat:@"Documents/%@/",[[array objectAtIndex:0] objectForKey:@"username"]];
    NSString*filepath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [manager fileExistsAtPath:filepath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [manager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@.mp4",filepath,_model.fileId];
    // 文件的属性会读取在字典当中
    NSDictionary * fileDic = [manager attributesOfItemAtPath:path error:nil];
    
    // 第一次接收到请求头 保存大小  文件名
    if (fileDic == nil) {
        
        // 创建文件
//        NSFileManager * manager = [NSFileManager defaultManager];
//        NSString *fileName = [NSString stringWithFormat:@"Documents/%@/%@.mp4",[[array objectAtIndex:0] objectForKey:@"username"],_model.fileId];
//        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        // 文件不存在 创建
        if (![manager fileExistsAtPath:path]) {
            [manager createFileAtPath:path contents:nil attributes:nil];
        }
        // 获取文件读写对象
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    }
    NSHTTPURLResponse * res = (NSHTTPURLResponse *)response;
    _totalSize = [res expectedContentLength];
    
    sum = _downLoadSize;
}

unsigned long long sum;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 追加写文件
    [_fileHandle writeData:data];
    // 进度
    sum += data.length;
    CGFloat f = (CGFloat)sum/_totalSize;
    NSLog(@"%f %llu %llu",f,sum,_totalSize);
    if (_processChange) {
        _processChange(f,_totalSize);
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 断开链接 关闭文件句柄
    [_fileHandle closeFile];
    [_connection cancel];
    if (_completeDownload) {
        _completeDownload(YES);
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // 断开链接 关闭文件句柄
    [_fileHandle closeFile];
    [_connection cancel];
    if (_completeDownload) {
        _completeDownload(NO);
    }
}

//- (void)_StartDownload
//{
//    // 获取文件大小
//    NSArray *array = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]];
//    NSString *fileName = [NSString stringWithFormat:@"Documents/%@/%@.mp4",[[array objectAtIndex:0] objectForKey:@"username"],_model.fileId];
//    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
//    NSFileManager * manager = [NSFileManager defaultManager];
//    // 文件的属性会读取在字典当中
//    NSDictionary * fileDic = [manager attributesOfItemAtPath:path error:nil];
//    // 如果没有保存资源名就是第一次下载该资源
//    if (fileDic == nil) {
//        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.fileUrl]];
//        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    }else{
//        // 不是第一次下载 写http RANGE字段
//        // 必须知道上一次下载了多少字节
//        
//        // 读取大小
//        NSNumber * num = [fileDic objectForKey:NSFileSize];
//        _downLoadSize = num.unsignedLongLongValue;
//        
//        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_model.fileUrl]];
//        // 写RANGE字段  RANGE:bytes=1000-
//        [request addValue:[NSString stringWithFormat:@"bytes=%lld-",_downLoadSize] forHTTPHeaderField:@"RANGE"];
//        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    }
//}
//
//- (void)_PauseDownload
//{
//    if (_connection) {
//        [_connection cancel];
//        _connection = nil;
//    }
//}

//- (void)_ResumeDownload
//{
//    
//}
//
- (void)_StartDownload
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:[VideoURLStringEncryption getNewURLStringWithPath:_model.fileUrl]];//请求地址
        
        _asiHttpRequest=[ASIHTTPRequest requestWithURL:url];
        _asiHttpRequest.delegate=self;
        _asiHttpRequest.downloadProgressDelegate=self;//下载进度的代理，用于断点续传
        
        //    NSString *downloadPath=@"下载的路径";
        //    NSString *tempPath=@"临时路径";//缓存路径，断点会打在这里面
        
        
        NSArray *array = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AllUserInfo.plist"]];
        NSString *fileName = [NSString stringWithFormat:@"Documents/%@/%@.mp4",[[array objectAtIndex:0] objectForKey:@"username"],_model.fileId];
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        
        /*
         临时路径:
         1.设置一个临时路径用来存储下载过程中的文件
         2.当下载完后会把这个文件拷贝到目的路径中，并删除临时路径中的文件
         3.断点续传：当设置断点续传的属性为YES后，每次执行都会到临时路径中寻找要下载的文件是否存在，下载的进度等等。。。然后就会在此基础上继续下载，从而实现续传的效果
         设置临时路径在这个过程中是相当重要的。。。
         */
        NSString *temp = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        /*
         又在临时路径中添加了一个mp3格式的文件,这就相当于设置了一个假的要下载的文件，其实是不存在的，可以这么理解：这里提供了一个容器，下载的内容填充到了这个容器中。
         这个容器是必须要设置的，要不然它会不知道要下载到什么里面。。。
         
         会有人说：问什么不和上面的临时路径拚在一起，不是一样么：NSString *temp = [path stringByAppendingPathComponent:@"temp/qgw.mp3"];
         这是不行的，因为你的临时路径必须要保证是正确的、是拥有的，所以在下面你要用NSFileManager来判断是否存在这么一个路径，如果不存在就去创建，
         当你创建的时候会把qgw.mp3当作是一个文件夹来创建的，所以每次断点续传的时候都会进入到qgw.mp3这个文件夹中寻找，当然是找不到的（因为qwg.mp3就是）
         so，要分开来写。。。
         
         */
        NSString *tempPath = [temp stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",_model.fileId]];
        
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //判断temp文件夹是否存在
        BOOL fileExists = [fileManager fileExistsAtPath:temp];
        if (!fileExists)
        {//如果不存在则创建,因为下载时,不会自动创建文件夹
            
            [fileManager createDirectoryAtPath:temp
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
            
        }
        
        [ _asiHttpRequest setDownloadDestinationPath:path ];//下载路径
        [ _asiHttpRequest setTemporaryFileDownloadPath:tempPath ];//临时路径，一定要设置临时路径。。
        
        _asiHttpRequest.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
        
        [_asiQueue addOperation:_asiHttpRequest];//加入队列
//    });
}

- (void)_PauseDownload
{
    [_asiHttpRequest clearDelegatesAndCancel];//停掉
}

//- (void)setProgress:(float)newProgress
//{
//    NSLog(@"%f",newProgress);
//}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
//    NSLog(@"newLength = %lld",newLength);
    _totalSize = newLength;
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    _downLoadSize += bytes;
    
    float value = (_downLoadSize*1.0)/(_totalSize*1.0);
//    NSLog(@"%f",value);
    if (_processChange) {
        _processChange(value,_totalSize);
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (_completeDownload) {
        _completeDownload(YES);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (_completeDownload) {
        _completeDownload(NO);
    }
}

@end
