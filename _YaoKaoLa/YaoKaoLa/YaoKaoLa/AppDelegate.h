//
//  AppDelegate.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/25.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ZHCourseChapterModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSInteger _networkingCount;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *courseArray;              //本地存储的课程
@property (nonatomic, strong) NSMutableArray *chapterArray;             //本地存储的章节
@property (nonatomic, strong) NSMutableArray *downloadArray;            //本地存储的下载信息
@property (nonatomic, retain)ZHCourseChapterModel *courseChapterModel;  //需要联网下载的model
@property (nonatomic, retain)NSMutableArray *downloadQueue;             //下载的列表
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign)BOOL isCall;
@property (nonatomic,assign)BOOL menuCall;
- (void)showMainViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//主页
- (void)showMainView;
//登录
- (void)showLogin;

+(AppDelegate *)sharedAppDelegate;
-(NSURL *)smartURLForString:(NSString *)str;
-(void)didStartNetworking;
-(void)didStopNetworking;

@end

