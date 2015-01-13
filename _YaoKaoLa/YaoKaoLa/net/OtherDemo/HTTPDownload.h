//
//  NSHTTPDownload.h
//  MiVTones
//
//  Created by Li Jianyun on 10-10-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPDownloadDelegate;
@class ZHCourseChapterModel;
@class HTTPDownload;

@interface HTTPDownload : NSObject {
    
	NSURLConnection *           _connection;
	NSString *                  _filePath;
    NSOutputStream *            _fileStream;
	
	long long downloadFileSize;
	long long totaleFileSize;
//    __unsafe_unretained NSIndexPath *indexPathHTTP;
//    __unsafe_unretained id<HTTPDownloadDelegate> delegate;
}

@property (nonatomic, weak)id <HTTPDownloadDelegate> delegate;
@property (nonatomic, readonly) BOOL              isReceiving;
@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, copy)   NSString		*filePath;
@property (nonatomic, retain) NSOutputStream *  fileStream;
@property (nonatomic, retain) ZHCourseChapterModel *courseChapterModel;
@property (nonatomic, assign) NSIndexPath *indexPathHTTP;

-(id)initWithCourseChapterModel:(ZHCourseChapterModel *)model;
-(void)_startReceive;
-(void)_ResumeReceive:(NSIndexPath *)indexPath;
-(BOOL)isReceiving;
-(void)canceledDownload;


@end

@protocol HTTPDownloadDelegate

@required
- (void)didDownloadBeginUpdateWithText:(NSString *)downloadStatusText withRow:(int)row;
- (void)didDownloadFinishedWithText:(NSString *)downloadStatusText withRow:(int)row;
- (void)didDownloadFailedWithErrorMessage:(NSString *)errMsg withRow:(int)row;
- (void)downloadUpdateProgressWithText:(NSString *)progressText withProgress:(float)p withRow:(int)row;

@end



