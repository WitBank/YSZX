//
//  ZHCoreDataManage.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHCoreDataManage.h"


@implementation ZHCoreDataManage
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YaoKaoLa" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *coreName = [NSString stringWithFormat:@"%@ZHCoreData.sqlite",[ud objectForKey:@"username"]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:coreName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }
}

#pragma mark - 缓存操作
////////////////////////////////////////////////////////////////////////////////////////////
//缓存操作
//-----------------------------------------------------------------------------------------------------------
#pragma mark - 咨询精选本地存储操作
//存储读取删除课程列表
+(void)saveCourseWithModelArray:(NSArray *)modelArray;
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    for (int i = 0; i < [modelArray count]; i++) {
        ZHCourseRootSourseModel *model = [modelArray objectAtIndex:i];
        ZHCourseRootSourseManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHCourseRootSourseManage" inManagedObjectContext:context];
        modelManage.acntNumber = model.acntNumber;
        modelManage.courseId = model.courseId;
        modelManage.courseName = model.courseName;
        modelManage.courseImg = model.courseImg;
        modelManage.courseContent = model.courseContent;
        modelManage.teacher = model.teacher;
        modelManage.endTime = model.endTime;
        modelManage.videoCount = model.videoCount;
        NSError *error;
        [context save:&error];
    }
}

+(NSArray *)getCourseModelArray
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseRootSourseManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *m_manage in manageArray) {
        ZHCourseRootSourseModel *model = [[ZHCourseRootSourseModel alloc] init];
        model.acntNumber = [m_manage valueForKey:@"acntNumber"];
        model.courseId = [m_manage valueForKey:@"courseId"];
        model.courseName = [m_manage valueForKey:@"courseName"];
        model.courseImg = [m_manage valueForKey:@"courseImg"];
        model.courseContent = [m_manage valueForKey:@"courseContent"];
        model.teacher = [m_manage valueForKey:@"teacher"];
        model.endTime = [m_manage valueForKey:@"endTime"];
        model.videoCount = [m_manage valueForKey:@"videoCount"];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(void)removeALLCourseModel
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseRootSourseManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *m_manage in manageArray) {
        [context deleteObject:m_manage];
    }
    [context save:nil];
}

//--------------------------------------------   我是邪恶的分隔符   -------------------------------
//存储读取删除课程章节
+(NSString *)saveCourseChapterModel:(ZHCourseChapterModel *)model
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    ZHCourseChapterManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHCourseChapterManage" inManagedObjectContext:context];
    modelManage.fileId = model.fileId;
    modelManage.fileName = model.fileName;
    modelManage.fileTime = model.fileTime;
    modelManage.fileUrl = model.fileUrl;
    modelManage.acntNumber = model.acntNumber;
    modelManage.courseId = model.courseId;
    modelManage.examinationId = model.examinationId;
    NSError *error;
    if(![context save:&error])
    {
        return [NSString stringWithFormat:@"失败：%@",[error localizedDescription]];
    }
    return (@"成功!!");
}
+(NSArray *)getAllCourseChapterModelArray
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseChapterManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *m_manage in manageArray) {
        ZHCourseChapterModel *model = [[ZHCourseChapterModel alloc] init];
        model.fileId = [m_manage valueForKey:@"fileId"];
        model.fileName = [m_manage valueForKey:@"fileName"];
        model.fileTime = [m_manage valueForKey:@"fileTime"];
        model.fileUrl = [m_manage valueForKey:@"fileUrl"];
        model.acntNumber = [m_manage valueForKey:@"acntNumber"];
        model.courseId = [m_manage valueForKey:@"courseId"];
        model.examinationId = [m_manage valueForKey:@"examinationId"];
        [modelArray addObject:model];
    }
    return modelArray;
}
+(void)removeAllCOurseChapterModelWithId:(NSString *)courseId
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseChapterManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    if (courseId == nil) {
        for (NSManagedObject *m_manage in manageArray) {
            [context deleteObject:m_manage];
        }
    }else{
        for (NSManagedObject *m_manage in manageArray) {
            if ([[m_manage valueForKey:@"courseId"] isEqualToString:courseId]) {
                [context deleteObject:m_manage];
            }
        }
    }
    [context save:&error];
}

//--------------------------------------------   我是邪恶的分隔符   -------------------------------
//存储和删除下载章节
+(NSString *)saveVideoDownloadModel:(ZHCourseChapterModel *)model
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    
    ZHCourseChapterDownloadManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHCourseChapterDownloadManage" inManagedObjectContext:context];
    modelManage.fileId = model.fileId;
    modelManage.fileName = model.fileName;
    modelManage.fileTime = model.fileTime;
    modelManage.fileUrl = model.fileUrl;
    modelManage.acntNumber = model.acntNumber;
    modelManage.courseId = model.courseId;
    modelManage.fileNumber = model.fileNumber;
    if ([model.isDownload isEqualToString:@"1"]) {
        modelManage.isDownload = model.isDownload;
    }else{
        modelManage.isDownload = @"0";
    }
    
    modelManage.examinationId = model.examinationId;
    NSError *error;
    if(![context save:&error])
    {
        return [NSString stringWithFormat:@"失败：%@",[error localizedDescription]];
    }
    return (@"成功!!");
}

+(void)saveDownloadCompleteWithModel:(ZHCourseChapterModel *)model
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseChapterDownloadManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    for (ZHCourseChapterDownloadManage *m_manage in manageArray) {
        if ([[m_manage valueForKey:@"fileId"] isEqualToString:model.fileId]) {
//            [m_manage setValue:@"1" forKey:@"isDownload"];
//            NSError *error;
//            [context save:&error];
            [context deleteObject:m_manage];
            [context save:&error];
            [ZHCoreDataManage saveVideoDownloadModel:model];
            return;
        }
    }
}

+(NSArray *)getAllDownloadVideoModelArray
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseChapterDownloadManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *m_manage in manageArray) {
        ZHCourseChapterModel *model = [[ZHCourseChapterModel alloc] init];
        model.fileId = [m_manage valueForKey:@"fileId"];
        model.fileName = [m_manage valueForKey:@"fileName"];
        model.fileTime = [m_manage valueForKey:@"fileTime"];
        model.fileUrl = [m_manage valueForKey:@"fileUrl"];
        model.acntNumber = [m_manage valueForKey:@"acntNumber"];
        model.courseId = [m_manage valueForKey:@"courseId"];
        model.isDownload = [m_manage valueForKey:@"isDownload"];
        model.fileNumber = [m_manage valueForKey:@"fileNumber"];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(void)removeDownloadVideoWithId:(NSString *)courseId
{
    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
    NSManagedObjectContext *context = [manage managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHCourseChapterDownloadManage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
    if (courseId == nil) {
        for (NSManagedObject *m_manage in manageArray) {
            [context deleteObject:m_manage];
        }
    }else{
        for (NSManagedObject *m_manage in manageArray) {
            if ([[m_manage valueForKey:@"courseId"] isEqualToString:courseId]) {
                [context deleteObject:m_manage];
            }
        }
    }
    [context save:&error];
}

////--------------------------------------------   我是邪恶的分隔符   -------------------------------
////收藏和删除新闻
//+(NSString *)saveInforMationCollectionWithModel:(ZHInformationCellModel *)model
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    
//    ZHInformationCollectionManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHInformationCollectionManage" inManagedObjectContext:context];
//    modelManage.titleimg = model.titleimg;
//    modelManage.title = model.title;
//    modelManage.pubdate = model.pubdate;
//    modelManage.contentString = model.contentString;
//    modelManage.categoryname = model.categoryname;
//    modelManage.categoryid = model.categoryid;
//    modelManage.newsid = model.newsid;
//    modelManage.contenturl = model.contenturl;
//    modelManage.author = model.author;
//    modelManage.contentHtmlUrl = model.contentHtmlUrl;
//    modelManage.belittle = model.belittle;
//    modelManage.praise = model.praise;
//    NSError *error;
//    if(![context save:&error])
//    {
//        return [NSString stringWithFormat:@"收藏失败：%@",[error localizedDescription]];
//    }
//    return (@"收藏成功!!");
//}
//+(NSArray *)getAllInformationCollectionModelWithNewsIdArray:(NSMutableArray *)newsIdArray
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHInformationCollectionManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
//    for (NSManagedObject *m_manage in manageArray) {
//        ZHInformationCellModel *model = [[ZHInformationCellModel alloc] init];
//        model.titleimg = [m_manage valueForKey:@"titleimg"];
//        model.title = [m_manage valueForKey:@"title"];
//        model.pubdate = [m_manage valueForKey:@"pubdate"];
//        model.contentString = [m_manage valueForKey:@"contentString"];
//        model.categoryname = [m_manage valueForKey:@"categoryname"];
//        model.categoryid = [m_manage valueForKey:@"categoryid"];
//        model.newsid = [m_manage valueForKey:@"newsid"];
//        model.contenturl = [m_manage valueForKey:@"contenturl"];
//        model.author = [m_manage valueForKey:@"author"];
//        model.praise = [m_manage valueForKey:@"praise"];
//        model.contentHtmlUrl = [m_manage valueForKey:@"contentHtmlUrl"];
//        model.belittle = [m_manage valueForKey:@"belittle"];
//        [modelArray addObject:model];
//        if (newsIdArray != nil) {
//            [newsIdArray addObject:model.newsid];
//        }
//    }
//    return modelArray;
//}
//+(void)removeinformationCollectionModelWithNewsId:(NSString *)newsId
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHInformationCollectionManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    if (newsId == nil) {
//        for (NSManagedObject *m_manage in manageArray) {
//            [context deleteObject:m_manage];
//        }
//    }else{
//        for (NSManagedObject *m_manage in manageArray) {
//            if ([[m_manage valueForKey:@"newsid"] isEqualToString:newsId]) {
//                [context deleteObject:m_manage];
//            }
//        }
//    }
//    [context save:&error];
//}
//
////------------------------------------------------------------------------------------------------------
////存储和删除一个深度专题新闻
//+(NSString *)saveSpecialNewsWithModel:(ZHSpecialCellModel *)model
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    
//    ZHSpecialCellManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHSpecialCellManage" inManagedObjectContext:context];
//    modelManage.titleimg = model.titleimg;
//    modelManage.title = model.title;
//    modelManage.pubdate = model.pubdate;
//    modelManage.contentString = model.contentString;
//    modelManage.categoryname = model.categoryname;
//    modelManage.categoryid = model.categoryid;
//    modelManage.newsid = model.newsid;
//    modelManage.contenturl = model.contenturl;
//    modelManage.author = model.author;
//    modelManage.contentHtmlUrl = model.contentHtmlUrl;
//    modelManage.belittle = model.belittle;
//    modelManage.praise = model.praise;
//    NSError *error;
//    if(![context save:&error])
//    {
//        return [NSString stringWithFormat:@"失败：%@",[error localizedDescription]];
//    }
//    return (@"成功!!");
//}
//+(NSArray *)getAllSpecialCellModel
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHSpecialCellManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
//    for (NSManagedObject *m_manage in manageArray) {
//        ZHSpecialCellModel *model = [[ZHSpecialCellModel alloc] init];
//        model.titleimg = [m_manage valueForKey:@"titleimg"];
//        model.title = [m_manage valueForKey:@"title"];
//        model.pubdate = [m_manage valueForKey:@"pubdate"];
//        model.contentString = [m_manage valueForKey:@"contentString"];
//        model.categoryname = [m_manage valueForKey:@"categoryname"];
//        model.categoryid = [m_manage valueForKey:@"categoryid"];
//        model.newsid = [m_manage valueForKey:@"newsid"];
//        model.contenturl = [m_manage valueForKey:@"contenturl"];
//        model.author = [m_manage valueForKey:@"author"];
//        model.praise = [m_manage valueForKey:@"praise"];
//        model.contentHtmlUrl = [m_manage valueForKey:@"contentHtmlUrl"];
//        model.belittle = [m_manage valueForKey:@"belittle"];
//        [modelArray addObject:model];
//    }
//    return modelArray;
//}
//+(void)removeSpecialNewsWithId:(NSString *)categoryId
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHSpecialCellManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    if (categoryId == nil) {
//        for (NSManagedObject *m_manage in manageArray) {
//                [context deleteObject:m_manage];
//        }
//    }else{
//        for (NSManagedObject *m_manage in manageArray) {
//            if ([[m_manage valueForKey:@"categoryid"] isEqualToString:categoryId]) {
//                [context deleteObject:m_manage];
//            }
//        }
//    }
//    [context save:&error];
//}
////--------------------------------------------   我是邪恶的分隔符   -------------------------------
////踩和赞的操作
//+(NSString *)savePraiseStepWithNewsId:(NSString *)newsId andPraise:(BOOL)isPraise
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    
//    ZHPraiseStepManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHPraiseStepManage" inManagedObjectContext:context];
//    modelManage.newId = newsId;
//    if (isPraise) {
//        modelManage.isPraise = @"1";
//    }else{
//        modelManage.isPraise = @"0";
//    }
//    NSError *error;
//    if(![context save:&error])
//    {
//        return [NSString stringWithFormat:@"失败：%@",[error localizedDescription]];
//    }
//    return (@"成功!!");
//}
////+(ZHPraiseStepType)getNewsTypeWithNewsId:(NSString *)newsId
////{
////    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
////    NSManagedObjectContext *context = [manage managedObjectContext];
////    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
////    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHPraiseStepManage" inManagedObjectContext:context];
////    [fetchRequest setEntity:entity];
////    NSError *error;
////    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
////    for (NSManagedObject *m_manage in manageArray) {
////        if ([[m_manage valueForKey:@"newId"] isEqualToString:newsId]) {
////            if ([[m_manage valueForKey:@"isPraise"] isEqualToString:@"1"]) {
////                return ZHPraiseStepTypeWithPraise;
////            }
////            return ZHPraiseStepTypeWithStep;
////        }
////    }
////    return ZHPraiseStepTypeWithNone;
////}
//+(NSArray *)getAllPraiseStepModel
//{
//    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHPraiseStepManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *m_manage in manageArray) {
//        ZHPraiseStepModel *model = [[ZHPraiseStepModel alloc] init];
//        model.newsId = [m_manage valueForKey:@"newId"];
//        model.isPraise = [m_manage valueForKey:@"isPraise"];
//        [modelArray addObject:model];
//    }
//    return modelArray;
//}
//+(void)removeAllPraise
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHPraiseStepManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//        for (NSManagedObject *m_manage in manageArray) {
//            [context deleteObject:m_manage];
//        }
//    [context save:&error];
//}
//
////--------------------------------------------   我是邪恶的分隔符   -------------------------------
////存储和删除一个视频页
//+(NSString *)saveHeathVideoWithModel:(HeathModel *)model
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    
//    ZHHeathManage *modelManage = [NSEntityDescription insertNewObjectForEntityForName:@"ZHHeathManage" inManagedObjectContext:context];
//    modelManage.categoryName = model.categoryName;
//    modelManage.categoryId = model.categoryId;
//    modelManage.newsId = model.newsId;
//    modelManage.title = model.title;
//    modelManage.descrip = model.descrip;
//    modelManage.contentUrl = model.contentUrl;
//    modelManage.author = model.Author;
//    modelManage.praise = model.praise;
//    modelManage.titleImg = model.titleImg;
//    modelManage.pubDate = model.pubDate;
//    modelManage.mediaPath = model.mediaPath;
//    NSError *error;
//    if(![context save:&error])
//    {
//        return [NSString stringWithFormat:@"失败：%@",[error localizedDescription]];
//    }
//    return (@"成功!!");
//}
//+(NSArray *)getAllHeathModel
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHHeathManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
//    for (NSManagedObject *m_manage in manageArray) {
//        HeathModel *model = [[HeathModel alloc] init];
//        model.titleImg = [m_manage valueForKey:@"titleImg"];
//        model.title = [m_manage valueForKey:@"title"];
//        model.pubDate = [m_manage valueForKey:@"pubDate"];
//        model.categoryName = [m_manage valueForKey:@"categoryName"];
//        model.categoryId = [m_manage valueForKey:@"categoryId"];
//        model.newsId = [m_manage valueForKey:@"newsId"];
//        model.contentUrl = [m_manage valueForKey:@"contentUrl"];
//        model.Author = [m_manage valueForKey:@"author"];
//        model.praise = [m_manage valueForKey:@"praise"];
//        model.descrip = [m_manage valueForKey:@"descrip"];
//        model.mediaPath = [m_manage valueForKey:@"mediaPath"];
//        [modelArray addObject:model];
//    }
//    return modelArray;
//}
//+(void)removeAllHeathModel
//{
//    ZHCoreDataManage *manage = [[ZHCoreDataManage alloc] init];
//    NSManagedObjectContext *context = [manage managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZHHeathManage" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *manageArray = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *m_manage in manageArray) {
//        [context deleteObject:m_manage];
//    }
//    [context save:&error];
//}
//
////--------------------------------------------   我是邪恶的分隔符   -------------------------------
////清空所有缓存
//+(void)removeAllModelCache
//{
//    [ZHCoreDataManage removeInformationTitleModel];
//    [ZHCoreDataManage removeInformationImageModelWithId:nil];
//    [ZHCoreDataManage removeSpecialNewsWithId:nil];
//    [ZHCoreDataManage removeAllHeathModel];
//    [ZHCoreDataManage removeAllPraise];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud removeObjectForKey:@"StartImage"];
//    [ud synchronize];
//}

@end
