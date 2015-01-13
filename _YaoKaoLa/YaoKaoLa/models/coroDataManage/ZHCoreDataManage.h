//
//  ZHCoreDataManage.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZHCourseRootSourseManage.h"
#import "ZHCourseChapterManage.h"
#import "ZHCourseChapterDownloadManage.h"


@interface ZHCoreDataManage : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//存储读取删除课程列表
+(void)saveCourseWithModelArray:(NSArray *)modelArray;
+(NSArray *)getCourseModelArray;
+(void)removeALLCourseModel;

//存储读取删除课程章节
+(NSString *)saveCourseChapterModel:(ZHCourseChapterModel *)model;
+(NSArray *)getAllCourseChapterModelArray;
+(void)removeAllCOurseChapterModelWithId:(NSString *)courseId;

//存储和删除下载中的视频
+(NSString *)saveVideoDownloadModel:(ZHCourseChapterModel *)model;
+(void)saveDownloadCompleteWithModel:(ZHCourseChapterModel *)model;
+(NSArray *)getAllDownloadVideoModelArray;
+(void)removeDownloadVideoWithId:(NSString *)courseId;

////收藏和删除新闻
//+(NSString *)saveInforMationCollectionWithModel:(ZHInformationCellModel *)model;
//+(NSArray *)getAllInformationCollectionModelWithNewsIdArray:(NSMutableArray *)newsIdArray;
//+(void)removeinformationCollectionModelWithNewsId:(NSString *)newsId;   //id传nil为删除所以收藏
//
////存储和删除一个深度专题新闻
//+(NSString *)saveSpecialNewsWithModel:(ZHSpecialCellModel *)model;
//+(NSArray *)getAllSpecialCellModel;
//+(void)removeSpecialNewsWithId:(NSString *)categoryId;
//
////踩和赞的操作
//+(NSString *)savePraiseStepWithNewsId:(NSString *)newsId andPraise:(BOOL)isPraise;
////+(ZHPraiseStepType)getNewsTypeWithNewsId:(NSString *)newsId;
//+(NSArray *)getAllPraiseStepModel;
//+(void)removeAllPraise;
//
////存储和删除一个视频页
//+(NSString *)saveHeathVideoWithModel:(HeathModel *)model;
//+(NSArray *)getAllHeathModel;
//+(void)removeAllHeathModel;
//
////清空所有缓存
//+(void)removeAllModelCache;

@end
