//
//  NSHTTPDownload.m
//  MiVTones
//
//  Created by Li Jianyun on 10-10-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTTPDownload.h"
#import "AppDelegate.h"
#import "ZHCourseChapterModel.h"
#import "CourseChapterDownloadTableView.h"
#import "VideoURLStringEncryption.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#pragma mark * Utilities
@interface NSString (HTTPExtensions)

-(BOOL)isHTTPContentType:(NSString *)prefixStr;

@end

@implementation NSString (HTTPExtensions)
-(BOOL)isHTTPContentType:(NSString *)prefixStr
{
	BOOL result;
	NSRange foundRange;
	
	result = NO;
	
	foundRange = [self rangeOfString:prefixStr options:NSAnchoredSearch | NSCaseInsensitiveSearch];
	
	if (foundRange.location != NSNotFound) {
		assert(foundRange.location == 0);
		if (foundRange.length == self.length) {
			result = YES;
		}
		else {
			unichar nextChar;
			
			nextChar = [self characterAtIndex:foundRange.length];
			result = nextChar <= 32 || nextChar >= 127 || (strchr("()<>@,;:\\<>/[]?={}", nextChar) != NULL);
		}
		
		
	}
	return result;
}

@end



@implementation HTTPDownload

@synthesize delegate;
@synthesize connection = _connection;
@synthesize filePath = _filePath;
@synthesize fileStream = _fileStream;

-(id)initWithCourseChapterModel:(ZHCourseChapterModel *)model
{
  
	if ((self = [super init])) 
	{
		self.courseChapterModel = model;
		downloadFileSize = 0;
		totaleFileSize = 0;
		self.connection = nil;
		self.filePath = nil;
		self.fileStream = nil;
        CourseChapterDownloadTableView *courseChapterDownloadTableView = [CourseChapterDownloadTableView shareDownloadController];
		self.delegate = courseChapterDownloadTableView;
    }
	return self;
}




#pragma mark * Status management
-(void)_receiveDidStart
{
	[[AppDelegate sharedAppDelegate] didStartNetworking];
}

-(void)_updateStatus:(NSString *)statusString
{
	assert(statusString != nil);
}

-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
	if (statusString == nil) {
		assert(self.filePath != nil);
	}
	else {
	}
	
	[[AppDelegate sharedAppDelegate] didStopNetworking];
}

#pragma mark * Core transfer code
-(void)canceledDownload
{
	ZHCourseChapterModel *courseModel = [[AppDelegate sharedAppDelegate].downloadQueue objectAtIndex:self.courseChapterModel.indexRow];
	courseModel.downloadFileSize = downloadFileSize;
	courseModel.totaleFileSize = totaleFileSize;
	
	if (self.connection != nil) 
	{
		[self.connection cancel];
		self.connection = nil;
	}

	if (self.fileStream != nil) 
	{
		[self.fileStream close];
		self.fileStream = nil;
	}
	[self _receiveDidStopWithStatus:nil];
	self.filePath = nil;
}

-(BOOL)isReceiving
{
	return (self.connection != nil);
}

-(void)_startReceive
{
	BOOL success;
	NSURL *url;
	NSURLRequest *request;
	
	url = [[AppDelegate sharedAppDelegate] smartURLForString:[VideoURLStringEncryption getNewURLStringWithPath:self.courseChapterModel.fileUrl]];
	
	success = (url != nil);
	if (! success) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Open the Video/Audio Request!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return;
	}
	else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
			NSString *documentsDirectory = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[ud objectForKey:@"username"]]];
			
			if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
				[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
			}
			
			self.filePath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",self.courseChapterModel.fileId];
			
			
			assert(self.filePath != nil);
			
			self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
			assert(self.fileStream != nil);
			
			[self.fileStream open];
			
			self.courseChapterModel.indexRow = (int)[[AppDelegate sharedAppDelegate].downloadQueue count];
			self.courseChapterModel.nsHTTPDownload = self;
			[AppDelegate sharedAppDelegate].courseChapterModel = self.courseChapterModel;
			
			request = [NSURLRequest requestWithURL:url];
			
			assert(request != nil);
			self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [[CourseChapterDownloadTableView shareDownloadController] updataTableView];
			
			assert(self.connection != nil);
			
			NSString *downloadStatusText = @"Prepare for download";
			[delegate didDownloadBeginUpdateWithText:(NSString *)downloadStatusText withRow:(int)self.courseChapterModel.indexRow];
			[self _receiveDidStart];
        //-----------------------------------------------------------------
	}
}

- (void)_stopReceiveWithStatus:(NSString *)statusString
{
	if (self.connection != nil) {
		[self.connection cancel];
		self.connection = nil;
	}
	if (self.fileStream != nil) {
		[self.fileStream close];
		self.fileStream = nil;
	}
	[self _receiveDidStopWithStatus:statusString];
	self.filePath = nil;
}
- (NSString *)_stringForNumber:(float)num asUnits:(NSString *)units
{
    NSString *  result;
    float      fractional;
    float      integral;
    
    fractional = modff(num, &integral);
    if ( (fractional < 0.1) || (fractional > 0.9) ) {
        result = [NSString stringWithFormat:@"%.2f %@", round(num), units];
    } else {
        result = [NSString stringWithFormat:@"%.2f %@", num, units];
    }
    return result;
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
	
#pragma unused(theConnection)
	NSHTTPURLResponse *httpResponse;
	NSString *contentTypeHeader;
	downloadFileSize = 0;
	totaleFileSize = 0;
	
	if ( [response expectedContentLength] != NSURLResponseUnknownLength )
    {
		if ([[AppDelegate sharedAppDelegate].downloadQueue count] != 0) {
		   ZHCourseChapterModel *courseModel = [[AppDelegate sharedAppDelegate].downloadQueue objectAtIndex:self.courseChapterModel.indexRow];
		  if (courseModel.downloadFileSize != 0 )
		  {
			totaleFileSize = courseModel.totaleFileSize;
			downloadFileSize = courseModel.downloadFileSize;
		  }
		  else 
		  {
			totaleFileSize = [response expectedContentLength];
		  }
		}
        
	}	
	httpResponse = (NSHTTPURLResponse *) response;
	assert([httpResponse isKindOfClass:[NSHTTPURLResponse class]]);
	if ((httpResponse.statusCode / 100) != 2) {
		[self _stopReceiveWithStatus:[NSString stringWithFormat:@"HTTP error %zd",(ssize_t) httpResponse.statusCode]];
	}
	else {
		contentTypeHeader = [httpResponse.allHeaderFields objectForKey:@"Content-Type"];
		if (contentTypeHeader == nil) {
			[self _stopReceiveWithStatus:@"No Content-Type!"];
			
		}
		else {
			//Respose OK.
		}
	}
}
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
	
	
		if (!(self.isReceiving)) 
		{
			ZHCourseChapterModel *courseModel = [[AppDelegate sharedAppDelegate].downloadQueue objectAtIndex:self.courseChapterModel.indexRow];
			courseModel.downloadFileSize = downloadFileSize;
			courseModel.totaleFileSize = totaleFileSize;
			return;
		}
	
#pragma unused(theConnection)
	NSInteger dataLength;
	const uint8_t *dataBytes;
	NSInteger bytesWritten;
	NSInteger bytesWrittenSoFar;
	dataLength = [data length];
	dataBytes = [data bytes];
	
	bytesWrittenSoFar = 0;
	do {
		bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
		assert(bytesWritten != 0);
		if (bytesWritten == -1) {
			[self _stopReceiveWithStatus:@"File write error"];
			break;
		}
		else {
			bytesWrittenSoFar += bytesWritten;
		}
		
	} while ( bytesWrittenSoFar != dataLength);
	
	downloadFileSize += (long long) dataLength;
	
	float totaleSize =[[NSNumber numberWithLongLong:totaleFileSize] floatValue];
	float downloadSize =[[NSNumber numberWithLongLong:downloadFileSize] floatValue];
	
	float progress = (downloadSize / totaleSize);
	
	 NSString *result;
	 if (downloadSize == 1) {
	 result = @"1 byte";
	 } else if (downloadSize < 1024) {
	 result = [NSString stringWithFormat:@"%f bytes", downloadSize];
	 } else if (downloadSize < (1024.0 * 1024.0 * 0.1)) {
	 result = [self _stringForNumber:downloadSize / 1024.0 asUnits:@"KB"];
	 } else if (downloadSize < (1024.0 * 1024.0 * 1024.0 * 0.1)) {
	 result = [self _stringForNumber:downloadSize / (1024.0 * 1024.0) asUnits:@"MB"];
	 } else {
	 result = [self _stringForNumber:downloadSize / (1024.0 * 1024.0 ) asUnits:@"MB"];
	 }
	NSString *downloadStatusText = [[NSString alloc] initWithFormat:@"%@/%0.2fMB",result,totaleSize/(1024.0 * 1024.0)];

	[self.delegate downloadUpdateProgressWithText:downloadStatusText
										 withProgress:progress
										  withRow:(int)self.courseChapterModel.indexRow];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
#pragma unused(theConnection)
#pragma unused(error)
	assert(theConnection == self.connection);
	
	[self _stopReceiveWithStatus:@"Connection failed"];
	[delegate didDownloadFailedWithErrorMessage:[error localizedDescription] withRow:(int)self.courseChapterModel.indexRow];
}	
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
#pragma unused(theConnection)
	assert(theConnection == self.connection);
	
	
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *documentsDirectory = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[ud objectForKey:@"username"]]];
//	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *destinctionPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",self.courseChapterModel.fileId];
	if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) 
	{
		if ([[NSFileManager defaultManager] fileExistsAtPath:destinctionPath])
		{
			[[NSFileManager defaultManager] removeItemAtPath:destinctionPath error:nil];
		}
		[[NSFileManager defaultManager] moveItemAtPath:self.filePath toPath:destinctionPath error:nil];
		//[[NSFileManager defaultManager] copyItemAtPath:self.filePath toPath:destinctionPath error:nil];
		//[[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
	}
	
	
	[self _stopReceiveWithStatus:nil];
	for (ZHCourseChapterModel *courseModel in [AppDelegate sharedAppDelegate].downloadQueue)
	{
		if (courseModel.fileName == self.courseChapterModel.fileName)
		{
			courseModel.isLoading = NO;
		}
	}

	NSString *downloadStatusText = @"Video did finish loading";
	[delegate didDownloadFinishedWithText:(NSString *)downloadStatusText withRow:(int)self.courseChapterModel.indexRow];
	
}

#pragma mark * DownloadsQueueControllerDelegate

-(void)_ResumeReceive:(NSIndexPath *)indexPath
{
	BOOL success;
	NSURL *url;
	NSMutableURLRequest *request;
	
	url = [[AppDelegate sharedAppDelegate] smartURLForString:[VideoURLStringEncryption getNewURLStringWithPath:self.courseChapterModel.fileUrl]];
	
	success = (url != nil);
	
	if (! success) {
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Open the Video/Audio Request!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alertView show];
		return;
	}
	else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *documentsDirectory = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[ud objectForKey:@"username"]]];
		if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
			[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
		}
	
		self.filePath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",self.courseChapterModel.fileId];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) 
		{
			
			assert(self.filePath != nil);
			
			self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
			assert(self.fileStream != nil);
			
			[self.fileStream open];
			
			
			ZHCourseChapterModel *courseModel = [[AppDelegate sharedAppDelegate].downloadQueue objectAtIndex:indexPath.row];
			courseModel.nsHTTPDownload = self;
			courseModel.indexRow = (int)indexPath.row;
			self.courseChapterModel.indexRow = courseModel.indexRow;
			
			NSString *downloadStatusText = @"Prepare for download";
			
			[delegate didDownloadBeginUpdateWithText:(NSString *)downloadStatusText withRow:(int)self.courseChapterModel.indexRow];
			
			request = [[NSMutableURLRequest alloc] initWithURL:url];
			
			assert(request != nil);
			float totaleSize =[[NSNumber numberWithLongLong:courseModel.totaleFileSize] floatValue];
			float downloadSize =[[NSNumber numberWithLongLong:courseModel.downloadFileSize] floatValue];
			NSString *contentRang = [[NSString alloc] initWithFormat:@" bytes=%d-%d",(int)downloadSize,(int)totaleSize];
			
			[request addValue:contentRang forHTTPHeaderField:@"Range"];
			[request setValue:contentRang forHTTPHeaderField:@"Range"];
			
			self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
			
			assert(self.connection != nil);
			
			
			[self _receiveDidStart];
		
		}
	}
}

-(void)dealloc
{
}
@end
